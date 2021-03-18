#!/bin/bash

ONDEMAND_USERNAME="$1"
if [ "x${ONDEMAND_USERNAME}" = "x" ]; then
  echo "Must specify username"
  exit 1
fi
HOOK_ENV="$2"
if [ "x${HOOK_ENV}" = "x" ]; then
  echo "Must specify hook.env path"
  exit 1
fi

source $HOOK_ENV

K8S_USERNAME="${K8S_USERNAME_PREFIX}${ONDEMAND_USERNAME}"

# we use pass ACCESS_TOKEN into the id-token arg. That's OK, it works and refreshes.
sudo -u "$ONDEMAND_USERNAME" kubectl config set-credentials "$K8S_USERNAME" \
   --auth-provider=oidc \
   --auth-provider-arg=idp-issuer-url="$IDP_ISSUER_URL" \
   --auth-provider-arg=client-id="$CLIENT_ID" \
   --auth-provider-arg=client-secret="$CLIENT_SECRET" \
   --auth-provider-arg=refresh-token="$OIDC_REFRESH_TOKEN" \
   --auth-provider-arg=id-token="$OIDC_ACCESS_TOKEN"
