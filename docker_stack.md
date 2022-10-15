# [DOCKER STACK](https://docs.docker.com/engine/reference/commandline/stack/)
docker engine modda iken kullanılan docker compose dosyasını docker swarm modda iken kullanılmasını sağlar. docker-compose.yml veya docker-compose.yaml dosyasında kullanılan bazı özellikler artık kullanılamayabilir. Örneğin mount binding yöntemi ile docker host üzerindeki bir klasörün kullanılamaması veya network oluşturulurken bridge netwrok üzerinden hareketle bir container oluşturulması gibi özellikler sistemin doğası olarak çalıştırılamayacaktır. Ayrıca Dockerfile build işlemide yapılamayacaktır.

| Command        | Description |
| -------------- | ----------- |
|`docker stack deploy --compose-file docker-compose.yml ilkstacksrv`|[docker-compoe.yml](/docker-compose/dockerstack/docker-compose.yml) üzerinden docker swarm moddaki üye node ler üzerinde yml dosyası içerisindeki service leri oluşturur. [docker stack deploy](https://docs.docker.com/engine/reference/commandline/stack_deploy/)|
|`docker stack ls`|stack kullanılarak oluşturulmuş stackleri listeler. [docker stack ls](https://docs.docker.com/engine/reference/commandline/stack_ls/)<br> ![docker stack](/img/docker_stack_p1.png)|
|`docker stack ps ilkstacksrv`|stack kullanılarak oluşturulmuş belirtilen stack içerisinde kaç tane service oluştuğunu hangi node üzerinde çalıştırıldığını gösterir. [docker stack ps](https://docs.docker.com/engine/reference/commandline/stack_ps/)<br> ![docker stack](/img/docker_stack_p2.png)|
|`docker stack services ilkstack`|stack kullanılarak oluşturulmuş belirtilen stack içerisinde kaç tane service listesini gösterir. [docker stack services](https://docs.docker.com/engine/reference/commandline/stack_services/)<br>![docker stack](/img/docker_stack_p3.png)|
|`docker service ls`| service listesini gösterir.|
|`docker service ps ilkstack_webserv`| belirtilen service detaylarını gösterir. ![docker service ps](/img/docker_stack_p4.png)|
|`docker service inspect ilkstack_webserv`| belirtilen service ile ilgili JSON olarak detaylı bilgi verir.|
|`docker stack rm ilkstack`| belirtilen stacki siler. [docker stack rm](https://docs.docker.com/engine/reference/commandline/stack_rm/)<br>![docker stack rm](/img/docker_stack_p5.png)|


# ORNEK UYGULAMA
[docker stack build docker-compose.yml](/docker-compose/wordpressmysql/stackfile/docker-compose.yml)

    cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 | docker secret create db_root_password -

    cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 | docker secret create wp_user_pass -`

    
`docker stack deploy --compose-file docker-compose.yml wpstack`\
`docker stack ls`\
`docker stack ps wpstack`\
`docker container ls`\
`docker container exec -ti 191f61ecf2fd bash`\
`cat /run/secrets/db_root_password`\
`cat /run/secrets/wp_user_pass`
