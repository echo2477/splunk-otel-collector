#!/bin/sh

# Copyright Splunk Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if command -v setcap >/dev/null 2>&1; then
    setcap CAP_SYS_PTRACE,CAP_DAC_READ_SEARCH=+eip /usr/bin/otelcol
fi

if [ -f /usr/lib/splunk-otel-collector/agent-bundle/bin/patch-interpreter ]; then
    /usr/lib/splunk-otel-collector/agent-bundle/bin/patch-interpreter /usr/lib/splunk-otel-collector/agent-bundle
fi

if [ -d /etc/otel/collector ]; then
    chown -R splunk-otel-collector:splunk-otel-collector /etc/otel/collector
fi

if [ -d /usr/lib/splunk-otel-collector ]; then
    chown -R splunk-otel-collector:splunk-otel-collector /usr/lib/splunk-otel-collector
fi

if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload
    systemctl enable splunk-otel-collector.service
    if [ -f /etc/otel/collector/splunk-otel-collector.conf ]; then
        echo "Starting splunk-otel-collector service"
        systemctl restart splunk-otel-collector.service
    fi
fi
