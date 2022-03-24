# gwtproject.org

Proposed docker-compose configuration and images to host the gwtproject.org website. This project
attempts to automate and document how the various subdomains of gwtproject.org are laid out and
what they should contain. This is designed to be customizable to mirror from any domain, either as
separate ports (by changing "expose" to "ports" in the docker-compose.yml file), or by putting a
reverse proxy in front of it to redirect by host name, etc.

The expected configuration is to run [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) and
[acme-companion](https://github.com/nginx-proxy/acme-companion) containers on the same server on
a specific network (parameterized by `NETWORK`) - when the containers in this configuration start up,
they will register themselves to be handled by the reverse proxy, and to get [Lets Encrypt](https://letsencrypt.org/)
certificates for the specified domain names.

The `.env` file has defaults for the various required settings - this file can be edited, or a
replacement .env file specified via `--env-file path/to/my.env` when running docker-compose commands.
The `production.env` file is intended to be the default values used when running the canonical
https://gwtproject.org/ website.