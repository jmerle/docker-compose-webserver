# Docker Compose Webserver

My docker-compose configuration for a OVH VPS I use that hosts some small web projects of mine. It contains a [Traefik](https://traefik.io/) container to serve as a reverse proxy with automatic Let's Encrypt SSL certificates and a [Watchtower](https://github.com/v2tec/watchtower) container to make sure my personal projects update automatically.

## Usage

1. Clone this repository.
2. Copy `.env.example` to `.env` and modify the variables.
3. Create a file called `transip.key` with as contents the [private TransIP key](https://www.transip.nl/cp/account/api/) to use when acquiring SSL certificates.
4. Run `./start.sh`.

To stop the services, run `docker-compose down`.

### Traefik

After starting the services, `traefik.example.com` and `traefik.example.com/ping` will be available (substitute example.com with the value of the `PRIMARY_DOMAIN` variable). The first one is guarded by the password specified in the `TRAEFIK_AUTH` variable and will redirect to the Traefik dashboard, while the second one doesn't have authentication and simply returns a HTTP 200 OK if everything's ok.

Traefik is configured to check for containers on the network specified by the `TRAEFIK_NETWORK` variable, so containers that need to be accessible by Traefik will also need to run on this network. Besides that, containers are not exposed by default, so you'll need to set the `traefik.enable` label to `true` on every container that needs to be exposed by Traefik.

When a new host rule is added, a Let's Encrypt SSL certificate is automatically acquired for it. The `LETS_ENCRYPT_EMAIL` variable specifies which email to set as the notification email.

### Watchtower

Watchtower is set to check for updates every 15 minutes. It will only check for updates on containers running with the label `com.centurylinklabs.watchtower.enable` set to `true`.
