#!/bin/bash

# Check if .env file exists
if [ -e .env ]; then
  source .env
else
  echo "Please copy the .env.example file to .env and fill it with correct values."
  exit 1
fi

# Create acme.json file
if [ ! -e acme.json ]; then
  touch acme.json
  chmod 600 acme.json
fi

# Create the docker-compose-network.yml file which enables inter-container routing
network="version: '3.5'
services:
  traefik:
    networks:
      traefik:
        aliases:
"

DOMAINS+=("traefik.${PRIMARY_DOMAIN}")
for i in ${DOMAINS[@]}; do
  network+="          - ${i}"
  network+=$'\n'
done

echo -e "$network\c" > docker-compose-network.yml

# Create the network if it does not exist yet
docker network inspect $TRAEFIK_NETWORK &>/dev/null || docker network create $TRAEFIK_NETWORK

# Start the containers
docker-compose -f docker-compose.yml -f docker-compose-network.yml up -d
