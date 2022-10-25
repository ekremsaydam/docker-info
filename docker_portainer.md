# PORTAINER
[portainer-ce](https://hub.docker.com/r/portainer/portainer-ce) 

[docker_portainer.md](/docker_portainer.md) ek bilgi olarak bakabilirsiniz. 

Docker sisteminin görsel olarak yönetilmesini sağlamak için sunulmuş bir uygulamadır. Aynı zamanda docker container olarak kullanılabilmesi de esneklik sağlarmaktadır.

# [KURULUM](https://docs.portainer.io/v/ce-2.9/start/install)
Üç farklı kurulum modu bulunmaktadır. [Set up a new Portainer Server installation](https://docs.portainer.io/v/ce-2.9/start/install/server) bu linkten erişebilirsiniz.

1. [Install Portainer with Docker on Linux](https://docs.portainer.io/v/ce-2.9/start/install/server/docker)

2. [Docker Swarm](https://docs.portainer.io/v/ce-2.9/start/install/server/swarm)

3. [Kubernetes](https://docs.portainer.io/v/ce-2.9/start/install/server/kubernetes)

# [Standalone Install Portainer with Docker on Linux](https://docs.portainer.io/v/ce-2.9/start/install/server/docker/linux)

Docker Host üzerinde bir container altında çalışması sağlanacak ise mutlaka ayrı bir volume üzerinde yapılan configurasyonların tutulması gereklidir. Sonrasında container çalışmama durumunda aynı volume yi kullanan yeni bir container ile kaldığımız yerden devam edilmesi sağlanabilir.

`docker volume create portainer_data` 

    docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce:2.9.3

https://localhost:9443/

![portainer](/img/docker_portainer_p01.png) \
![portainer](/img/docker_portainer_p02.png) \
![portainer](/img/docker_portainer_p03.png) \
![portainer](/img/docker_portainer_p04.png) 

# [Docker Swarm Install Install Portainer with Docker Swarm on Linux](https://docs.portainer.io/v/ce-2.9/start/install/server/swarm/linux)

`docker swarm init` 

    curl -L https://downloads.portainer.io/portainer-agent-stack.yml \
        -o portainer-agent-stack.yml

`docker stack deploy -c portainer-agent-stack.yml portainer`

# REGISTRY KURULUM (PORTAINER ile)
Şimdiye kadar hep hub.docker.com üzerinden image pull ve push işlemlerini yaptık. Docker Hub 1 tane private repository e izin vermektedir. Kurumumuza özel repository i bir noktada saklama ihtiyacını gidermek için registry kullanılabilir.

Yada offline olarak internal kurum içerisinde repository lerimizi tutmak isteyebiliriz. Bunun için çözümümüz REGISTRY dir.

Ayrıca kurum içerisinde hızlı işlemler yapmak içinde kullanılabilir. İç ağdaki bir sistemden image indirmek hız kazandıracaktır.


Kuruluma geçmeden önce registry isminde bir volume oluşturmayı unutmayınız. \
![registry](/img/docker_portainer_registry_p01.png) \
![registry](/img/docker_portainer_registry_p02.png) \
![registry](/img/docker_portainer_registry_p03.png) \

`docker pull ubuntu` \
`docker image tag nginx:latest 127.0.0.1:5000/nginx` \
`docker image push 127.0.0.1:5000/nginx`

http://localhost:5000/v2/_catalog


## [DOCKER EVENTS](https://docs.docker.com/engine/reference/commandline/events/)
Docker host üzerinde gerçek zamanlı olaylar almak için kullanılır. Varsayılan olarak 1000 günlük olayları barındırabilir.
`docker events` \
![docker events](/img/docker_events_p01.png)

portainer üzerinden de events lere bakılabilir.

![portainer events](/img/docker_portainer_events_p01.png)

## [DOCKER STATS](https://docs.docker.com/engine/reference/commandline/stats/)

Container ların kaynak kullanımını anlık olarak gösterir.

`docker stats` \
![docker stats](/img/docker_stats_p01.png)

portainer üzerinden stats grafiksel olara bakılabilir. 

![portainer stats](/img/docker_portainer_stats_p01.png) \
![portainer stats](/img/docker_portainer_stats_p02.png)