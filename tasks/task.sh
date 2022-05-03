#!/bin/bash

set -euxo pipefail

# todo (mxplusb): update the auth mechanism.
cf login -a "$CF_API_URL" -u "$CF_USERNAME" -p "$CF_PASSWORD" -o "$CF_ORGANIZATION" -s "$CF_SPACE"

# Clean up existing app and service if present
cf delete -f "demo-test-$SERVICE_PLAN"
cf delete-service -f "rds-demo-test-$SERVICE_PLAN"

# change into the directory and push the app without starting it.
# this comes from the cloud.gov/laboratory repo an app to test the db is working
pushd aws-db-test/databases/aws-rds
cf push "demo-test-${SERVICE_PLAN}" -f manifest.yml --no-start

# set some variables that it needs
cf set-env "demo-test-${SERVICE_PLAN}" DB_TYPE "${DB_TYPE}"
cf set-env "demo-test-${SERVICE_PLAN}" SERVICE_NAME "rds-demo-test-$SERVICE_PLAN"

# Create service

cf create-service aws-rds "$SERVICE_PLAN" "rds-demo-test-$SERVICE_PLAN"

while true; do
  if out=$(cf bind-service "demo-test-${SERVICE_PLAN}" "rds-demo-test-$SERVICE_PLAN"); then
    break
  fi
  if [[ $out =~ "Instance not available yet" ]]; then
    echo "${out}"
  fi
  sleep 90
done

# wait for the app to start. if the app starts, it's passed the smoke test.
cf push "demo-test-${SERVICE_PLAN}"

# Clean up app and service
cf delete -f "demo-test-$SERVICE_PLAN"
cf delete-service -f "rds-demo-test-$SERVICE_PLAN"