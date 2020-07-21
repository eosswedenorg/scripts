#!/bin/bash

ACCOUNT="ACCOUNT_NAME"
CONTRACT="delphioracle"

get_price() {
  echo $(echo "$1" | jq -c ".$2") $3 | awk {'printf "%d",$1*$2'}
}

unlock_wallet() {
  ${CLEOS} --wallet-url ${WALLET_URL} unlock --password "PW5................"
}

URL="https://min-api.cryptocompare.com/data/price?fsym=WAX&tsyms=BTC,USD"
CLEOS="Path-to-cleos"
API_URL="https://api.waxsweden.org"
WALLET_URL="http://127.0.0.1:8888"

PRICES=$(curl "$URL" 2> /dev/null)

PAYLOAD=$(cat << EOF
'{
  "owner": "$ACCOUNT",
  "quotes": [
    {
      "pair": "waxpusd",
      "value": "$(get_price $PRICES \"USD\" 10000)"
    },
    {
      "pair": "waxpbtc",
      "value": "$(get_price $PRICES \"BTC\" 100000000)"
    }
  ]
}'
EOF
)

unlock_wallet 1>/dev/null 2>&1

echo $PAYLOAD > /tmp/update_delphi_oracle.tmp

eval ${CLEOS} -u ${API_URL} --wallet-url ${WALLET_URL} push action $CONTRACT write $(cat /tmp/update_delphi_oracle.tmp) -p ${ACCOUNT}@oracle
