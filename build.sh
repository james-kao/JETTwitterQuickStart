#!/bin/bash

# Build script to package Node.js app w/ APM Agent

# Make sure that the following environment varibles are set:
#   AGENTINSTALL_ZIP_URL
#   AGENT_REGISTRATION_KEY
# It's recommended that you put the AgentInstall.zip you get from the
# OMC tenant into the Maven tenant and use the URL to the artifact.

# Setup proxy
if [ -n "$HTTP_PROXY" ]; then
  echo "HTTP Proxy is set to ${HTTP_PROXY}"
  PROXY_ARG="--proxy ${HTTP_PROXY}"
  export http_proxy=${HTTP_PROXY}
  export https_proxy=${HTTP_PROXY}
fi

# Check APM Agent Env Prerequisites
echo "AgentInstall.zip DL URL: ${AGENTINSTALL_ZIP_URL}"
echo "apm_stage.zip DL URL: ${APMSTAGE_ZIP_URL}"
if [[ -z ${AGENTINSTALL_ZIP_URL} ]] && [[ -z ${APMSTAGE_ZIP_URL} ]]; then
  echo "Make sure AGENTINSTALL_ZIP_URL or APMSTAGE_ZIP_URL are set"
  exit 1
fi

echo "Agent Registration Key: ${AGENT_REGISTRATION_KEY}"
if [[ -z ${AGENT_REGISTRATION_KEY} ]]; then
  echo "Make sure AGENT_REGISTRATION_KEY is set"
  exit 1
fi

# Clean up any artifacts left from previous builds

# Setup staging directories
mkdir agent_stage

pushd .
cd agent_stage
# If we provided an APMSTAGE URL, use that, otherwise use AgentInstall.sh
if [[ ${APMSTAGE_ZIP_URL} ]]; then
  curl -o apm_stage.zip "${APMSTAGE_ZIP_URL}"
  unzip apm_stage.zip
else
  curl -o AgentInstall.zip "${AGENTINSTALL_ZIP_URL}"
  unzip AgentInstall.zip -d .
  chmod a+rx AgentInstall.sh
  ./AgentInstall.sh AGENT_TYPE=apm_nodejs_agent STAGE_LOCATION=../ext/apm_stage AGENT_REGISTRATION_KEY="${AGENT_REGISTRATION_KEY}"
  chmod a+rx ../ext/apm_stage/*.sh
fi

npm install
