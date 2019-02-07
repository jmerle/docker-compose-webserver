#!/bin/bash

# Check if .env file exists
if [ -e .env ]; then
  source .env
else
  echo "Please copy the .env.example file to .env and fill it with correct values."
  exit 1
fi

# Check if the private TransIP key file exists
if [ ! -e transip.key ]; then
  echo "Please create a transip.key file containing your private TransIP key which is used when creating SSL certificates."
  exit 1
fi

# Create acme.json file
if [ ! -e acme.json ]; then
  touch acme.json
  chmod 600 acme.json
fi

# Create the acme.domains arguments
for i in ${!ALL_DOMAINS[@]}; do
  domain="${ALL_DOMAINS[$i]}"

  domains="--acme.domains='*.$domain,$domain'"
  if [ "$i" -eq "0" ]; then
    export TRAEFIK_DOMAINS="$domains"
  else
    export TRAEFIK_DOMAINS="$TRAEFIK_DOMAINS $domains"
  fi
done

# Create the network if it does not exist yet
docker network inspect $TRAEFIK_NETWORK &>/dev/null || docker network create $TRAEFIK_NETWORK

# Start the containers
docker-compose up -d
