#! bin/bash

# Start the container
docker compose up -d --force-recreate

# Setup the primary DNS records inside the container so web GUIs are accessible
docker exec pihole bash -c 'pihole-FTL --config dns.hosts "[\"192.168.1.99 beast.local\"]"'
sudo docker exec pihole bash -c 'pihole-FTL --config dns.cnameRecords "[\"pihole.${SUBDOMAIN}.${DOMAIN},beast.local\", \"traefik-dashboard.${SUBDOMAIN}.${DOMAIN},beast.local\"]"'
