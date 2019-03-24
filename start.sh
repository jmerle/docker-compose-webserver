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

# Create the network if it does not exist yet
docker network inspect $TRAEFIK_NETWORK &>/dev/null || docker network create $TRAEFIK_NETWORK

# Start the containers
docker-compose up -d
