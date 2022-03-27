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

For testing purposes, "gwtproject.org" is abstracted out and can be redefined. For example, if
you control the domain name "example.com" you could define "gwt.example.com" to be the "BASE_DOMAIN"
for this project, so "www.gwt.example.com" and "samples.gwt.example.com" would host the website and
samples, respectively.

Three explicit domains are handled today:

 * `BASE_DOMAIN` (aka gwtproject.org) - this redirects to www.`BASE_DOMAIN`
 * www.`BASE_DOMAIN` (or www.gwtproject.org) - this contains the rendered HTML contents from
   https://github.com/gwtproject/gwt-site.
 * samples.`BASE_DOMAIN` (or samples.gwtproject.org) - this contains the samples that are shipped with
   each release of GWT, though they are deployed to the subdirectory /samples/. Contents are served as
   static content for now, reflecting the behavior from when Google controlled the site, meaning that
   each example's html file must be specified (the <welcome-file> in the `web.xml` file has no effect),
   and `WEB-INF/` contents are visible. One change made in this deployment was to include an `index.html`
   file so that samples.gwtproject.org and samples.gwtproject.org/samples will redirect to the showcase
   instead of just displaying an error.


# Environment variables
There are three environment variables that are used to start these containers.

 * `BASE_DOMAIN` - as discussed above, `BASE_DOMAIN` is used to handle redirects from the bare domain to
   www, and is also used to automatically set container-specific environment variables for nginx-proxy
   to forward incoming requests to by host name.
 * `NGINX_TAG` - the tagged nginx docker image that these images should be based on.
 * `NETWORK` - the prefix of the name of the docker network to join. If the network does not exist, it
   will be created. This is intended to be used to run nginx-proxy and acme-companion in one set of
   docker-compose services, and make these containers available to them.

# Example usage

To start these processes with the defaults specified in `.env`, simply invoke `docker-compose up --build`,
or first invoke `docker-compose build` and then `docker-compose up`.

To use the `production.env` file, pass `--env-file production.env` to all commands, to make sure the values
are used not only when making the images, but also when starting them.

To stop the servers, hit `ctrl-c`.

To start the server in "detached" mode, add the `-d` flag in the `up` commands, such as `docker-compose up -d --build`.
This will return after building and starting the server. Then, to stop, use `docker-compose stop`.

## With no proxy server, or with your own proxy server

While the containers are running, you can use `docker-compose ps` to see what ports are in use:

```
$ docker-compose ps
Name                           Command               State                   Ports
----------------------------------------------------------------------------------------------------------------
gwtprojectorg_static-samples_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:49193->80/tcp,:::49193->80/tcp
gwtprojectorg_www_1              /docker-entrypoint.sh ngin ...   Up      0.0.0.0:49194->80/tcp,:::49194->80/tcp
```
This tells us that to open the www contents, open `http://localhost:49194` in a web browser, and to open the
samples, open `http://localhost:49193`.

Without nginx-proxy, the `BASE_DOMAIN` only serves to handle redirects from the bare domain to www, and
could be left off if no proxy server will be used. Give the port numbers to your proxy server, or open them in the
browser directly.

To set `BASE_DOMAIN` set the environment variable before running docker commands, such as

```
$ export BASE_DOMAIN=gwtproject.org.foo.com
$ docker-compose build
...
$ docker-compose up
...
```

or
```
$ BASE_DOMAIN=gwtproject.org.foo.com docker-compose up --build -d
...
```

## With [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)

The defaults defined in `.env` assume that your nginx-proxy (and optional acme-companion) are running in a project
called `web` - if this is not true, the `NETWORK` environment variable will need to be set to the actual name in
use.

Likewise, `BASE_DOMAIN` will need to be set, unless you plan on using the default set in `.env`, or in `production.env`.

For example, if this was the contents of `proxy/docker-compose.yml`, and `docker-compse up -d` was run in the `proxy`
directory, the `gwtproject.org/docker-compose.yml` would need `NETWORK` to be set to `proxy`.
```yaml
# Example from https://github.com/nginx-proxy/nginx-proxy/blob/main/docker-compose.yml, plus 443
version: '2'
services:
  nginx-proxy:
    image: nginxproxy/nginx-proxy
    container_name: nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
```
This file gives nginx-proxy access to read and write to docker, and

Building and starting gwtproject.org could then look like
```shell
$ BASE_DOMAIN=gwt.mycompany.com NETWORK=proxy docker-compose up --build -d
...
```
