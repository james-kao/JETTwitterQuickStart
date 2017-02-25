#!/bin/bash

# APM Startup Wrapper for ACCS Node.JS
# For use with pre-provisioned APM stage folder in APM_STAGE

APM_STAGE=${APP_HOME}/ext/apm_stage
echo "APM_STAGE: ${APM_STAGE}"

APM_PROP_FILE=${APM_STAGE}/oracle-apm-config.json
export NODE_APP_HOME=${APP_HOME}

# Setup npm to allow global installation w/o root
mkdir "${APP_HOME}/.npm-packages"
echo "prefix=${APP_HOME}/.npm-packages" >> ~/.npmrc
export NPM_PACKAGES="${APP_HOME}/.npm-packages"
export PATH="${NPM_PACKAGES}/bin:$PATH"

pushd .
cd ${APM_STAGE}
sed "/pathToCertificate/d" -i.orig ${APM_PROP_FILE}
echo "PWD: `pwd`"

echo "ls -l:"
ls -l

cat ${APM_PROP_FILE}
chmod a+rx ProvisionApmNodeAgent.sh
echo 'y' | ./ProvisionApmNodeAgent.sh
popd

# Setup APM log output
mkdir -p oracle-apm/logs
touch oracle-apm/logs/Agent_apmwrapper.log
tail -F oracle-apm/logs/Agent_apmwrapper.log &

# Setup environment
export NODE_PATH=`npm -g prefix`/lib/node_modules

echo "ls -l ${NODE_PATH}/oracle-apm/data"
ls -l ${NODE_PATH}/oracle-apm/data
cat ${NODE_PATH}/oracle-apm/data/emcs.cer

( sleep 60 ; oracle-apm config list ) &

curl -vvI https://oraclepaastrial01.itom.management.us2.oraclecloud.com/static/regmanager/agents

# Launch first parameter as JS script filename, passing remaining parameters as args to that script
EXEC_BINARY="node"
exec "$EXEC_BINARY" apmwrapper.js "$@"
