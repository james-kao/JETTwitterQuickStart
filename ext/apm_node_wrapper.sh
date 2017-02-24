#!/bin/bash

# APM Startup Wrapper for ACCS Node.JS
# For use with pre-provisioned APM stage folder in APM_STAGE

APM_STAGE=${APP_HOME}/ext/apm_stage
echo "APM_STAGE: ${APM_STAGE}"

pushd .
cd ${APM_STAGE}
chmod a+rx ProvisionApmNodeAgent.sh
./ProvisionApmNodeAgent.sh
popd

# Any APM agent customizations here by calling oracle-apm

# Setup environment
export NODE_PATH=`npm -g prefix`/lib/node_modules

# Launch first parameter as JS script filename, passing remaining parameters as args to that script
EXEC_BINARY="node"
exec "$EXEC_BINARY" "apmwrapper.js $@"
