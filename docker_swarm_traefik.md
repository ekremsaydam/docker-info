[Traefik & Docker](https://doc.traefik.io/traefik/providers/docker/) \
[EntryPoints](https://doc.traefik.io/traefik/routing/entrypoints/) \
[Migration Guide: From v1 to v2](https://doc.traefik.io/traefik/migration/v1-to-v2/) \
[BasicAuth](https://doc.traefik.io/traefik/middlewares/http/basicauth/) \
[Docker-compose basic example](https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/) \
[Let's Encrypt](https://doc.traefik.io/traefik/https/acme/)
[Docker-compose with let's encrypt: TLS Challenge](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-tls/)


[Traefik Enterprise Installation Quick Start](https://doc.traefik.io/traefik-enterprise/getting-started/)

[Traefik With the Docker](https://doc.traefik.io/traefik/getting-started/quick-start/)

[The Dashboard](https://doc.traefik.io/traefik/operations/dashboard/)

[Static Configuration: CLI](https://doc.traefik.io/traefik/reference/static-configuration/cli/)



<hr>

[docker-compose.yml](/docker-compose/traefik/docker-compose.yml) \
`docker swarm init` \
`docker stack deploy --compose-file docker-compose.yml traefik` \
![traefik](/img/docker_traefik_p01.png)


## ÖRNEK 1
[traefik hub.docker.com](https://hub.docker.com/_/traefik)

    ## traefik.yml

    # Docker configuration backend
    providers:
    docker:
        defaultRule: "Host(`{{ trimPrefix `/` .Name }}.docker.localhost`)"

    # API and dashboard configuration
    api:
    insecure: true

<hr>

    docker run -d -p 8080:8080 -p 80:80 \
    -v $PWD/traefik.yml:/etc/traefik/traefik.yml \
    -v /var/run/docker.sock:/var/run/docker.sock \
    traefik:v2.5

## ÖRNEK 2
[](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-v2-as-a-reverse-proxy-for-docker-containers-on-ubuntu-20-04)
[acme.json](/docker-compose/traefik/daemon/acme.json) \
[traefik.toml](/docker-compose/traefik/daemon/traefik.toml) \
[traefik_dynamic.toml](/docker-compose/traefik/daemon/traefik_dynamic.toml) \

`sudo apt-get install apache2-utils` \
`htpasswd -nb admin password` \
admin:$apr1$66GBRxC6$P7t9jwf3vc2S8wPEWZ/u6/

`docker network create web` \

    docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD/traefik.toml:/traefik.toml \
    -v $PWD/traefik_dynamic.toml:/traefik_dynamic.toml \
    -v $PWD/acme.json:/acme.json \
    -p 80:80 \
    -p 443:443 \
    --network web \
    --name traefik \
    traefik:v2.2

## ÖRNEK 3

[docker-compose.yml](/docker-compose/traefik/onswarm/traefik/docker-compose.yml)

`docker network create --driver overlay traefiknet` 

[CoreDNS Manual](https://coredns.io/manual/toc/#authoritative-serving-from-files) \
`docker stack deploy -c docker-compose.yml coredns` \
`docker stack ps coredns` \
`docker logs coredns_coredns.1.l9y3byna2pjhqsp5g01mlz442` \
![coredns](/img/docker_coredns_p01.png)

`docker stack deploy -c docker-compose.yml traefik` \
`docker stack ps traefik` \
`docker stack services traefik` 


# ÖRNEK 4 - Dışarıda HTTPS içerde HTTP

[docker-compose.yml](/docker-compose/traefik/onswarm/traefik/https/docker-compose.yml)

`docker network create --opt encrypted --driver overlay --attachable traefiknet` 

[CoreDNS Manual](https://coredns.io/manual/toc/#authoritative-serving-from-files) \
`docker stack deploy -c docker-compose.yml coredns` \
`docker stack ps coredns` \
`docker logs coredns_coredns.1.l9y3byna2pjhqsp5g01mlz442` \
![coredns](/img/docker_coredns_p01.png)

`docker stack deploy --compose-file docker-compose.yml traefik` \
`docker stack ps traefik` \
`docker stack services traefik` 


# ÖRNEK 4 - Dışarıda HTTPS içerde HTTP a- Şifreli

[docker-compose.yml](/docker-compose/traefik/onswarm/traefik/https-auth/docker-compose.yml)

`docker network create --opt encrypted --driver overlay --attachable traefiknet` 

[CoreDNS Manual](https://coredns.io/manual/toc/#authoritative-serving-from-files) \
`docker stack deploy -c docker-compose.yml coredns` \
`docker stack ps coredns` \
`docker logs coredns_coredns.1.l9y3byna2pjhqsp5g01mlz442` \
![coredns](/img/docker_coredns_p01.png)

`docker stack deploy --compose-file docker-compose.yml traefik` \
`docker stack ps traefik` \
`docker stack services traefik` 

