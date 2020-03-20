# export API_TOKEN=""
# export APP_NAME=""
# export OWNER=""
RESPONSE=$(mktemp /tmp/appcenter-response.XXXXXX)

create_release_uploads() {
  # Note: build_version and build_number parsed and checked in the server side. Different values are not accepted.
  #--data "{\"build_version\":\"$VERSION\", \"build_number\":\"$NUMBER\"}" \
  local status=$(curl -s -X POST \
  --write-out %{http_code} \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "X-API-Token: $API_TOKEN" \
  -o $RESPONSE \
  "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/release_uploads")

  if [ $status -lt 200 ] || [ $status -gt 299 ]; then
    echo "create release_uploads error: $(cat $RESPONSE | jq -r '.message')"
    exit 1
  fi
  cat $RESPONSE
}

put_release_notes() {
  local release_id=$1
  local rel_notes=$(tr -d '\015' < $2 | sed -e ':loop' -e 'N' -e '$!bloop' -e 's/\\/\\\\/g' -e 's/\n/\\n/g' -e 's/\"/\\"/g')

  local status=$(curl -s -X PUT \
  --write-out %{http_code} \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "X-API-Token: $API_TOKEN" \
  -o $RESPONSE \
  --data "{ \"release_notes\": \"$rel_notes\"}" \
  "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/releases/$release_id")

  if [ $status -lt 200 ] || [ $status -gt 299 ]; then
    echo "create release_uploads error: $(cat $RESPONSE | jq -r '.message')"
    exit 1
  fi
  cat $RESPONSE
}

update_release_uploads_status() {
  local upload_id=$1
  local rel_status=$2

  local status=$(curl -s -X PATCH \
  --write-out %{http_code} \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "X-API-Token: $API_TOKEN" \
  -o $RESPONSE \
  --data "{ \"status\": \"$rel_status\"}" \
  "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/release_uploads/$upload_id")

  if [ $status -lt 200 ] || [ $status -gt 299 ]; then
    echo "update release_uploads status error: $(cat $RESPONSE | jq -r '.message')"
    exit 1
  fi
  cat $RESPONSE
}

distribute_testers() {
  local release_id=$1
  local email=$2
  local mandatory_update=$3
  local notify_testers=$4

  local status=$(curl -s -X POST \
  --write-out %{http_code} \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --header "X-API-Token: $API_TOKEN" \
  -o $RESPONSE \
  --data "{ \"email\": \"$email\", \"mandatory_update\": ${mandatory_update}, \"notify_testers\": ${notify_testers}}" \
  "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/releases/$release_id/testers")

  if [ $status -lt 200 ] || [ $status -gt 299 ]; then
    echo "distribute testers error: $(cat $RESPONSE | jq -r '.message')"
    exit 1
  fi
}

distribute_groups() {
  local release_id=$1
  local group_id=$2
  local mandatory_update=$3
  local notify_testers=$4


  local status=$(curl -s -X POST \
  --write-out %{http_code} \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --header "X-API-Token: $API_TOKEN" \
  -o $RESPONSE \
  --data "{ \"id\": \"$group_id\", \"mandatory_update\": ${mandatory_update}, \"notify_testers\": ${notify_testers}}" \
  "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/releases/$release_id/groups")

  if [ $status -lt 200 ] || [ $status -gt 299 ]; then
    echo "distribute groups error: $(cat $RESPONSE | jq -r '.message')"
    exit 1
  fi
}

distribute_store() {
  local release_id=$1
  local store_id=$2

  local status=$(curl -s -X POST \
  --write-out %{http_code} \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --header "X-API-Token: $API_TOKEN" \
  -o $RESPONSE \
  --data "{ \"id\": \"$store_id\"}" \
  "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/releases/$release_id/stores")

  if [ $status -lt 200 ] || [ $status -gt 299 ]; then
    echo "distribute stores error: $(cat $RESPONSE | jq -r '.message')"
    exit 1
  fi
}