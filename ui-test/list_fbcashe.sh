#!/bin/bash

source ../.env # you have to set FB_ACCESS_TOKEN='{your access token}' in the .env file

LANGS="en"

PAGES=$(cat <<EOT
details-of-confirmed-cases
number-of-confirmed-cases
attributes-of-confirmed-cases
number-of-tested
number-of-reports-to-covid19-telephone-advisory-center
predicted-number-of-toei-subway-passengers
EOT
)

for page in $PAGES; do
  for lang in $LANGS; do
    echo "https://iwate.stopcovid19.jp/${lang}/cards/${page}"
  done
  echo "https://iwate.stopcovid19.jp/cards/${page}"
done
