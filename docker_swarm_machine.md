# [DOCKER SWARM](https://docs.docker.com/engine/reference/commandline/swarm/)
Swarm orchestrator; docker hostların bir cluster (küme) halinde dağıtımının, yönetiminin ve ölçeklendirilmesinin sağlayan bir yapıdır.

Swarm içerisinde her bir docker host node olarak adlandırılır. Bu docker host lar sanal yada fiziksel yada cloud üzerinde bir makine olabilir.

Swarm üzerindeki node lar birbirleri arasında ağ yapısı üzerinden iletişim kurabilirler.

İki tip Node vardır.
1. Manager (Yönetici)
2. Worker (işçi)

Swarm üzerinde worker node üzerinde container ları çalıştıran yapılara services denir.

Swarm için ayrı bir kuruluma gerek yoktur.
<hr>

## 1. Manager Node (Yönetici):
Yönetici node lar cluster durumunu kontrol ederek işçi node'leri yapılacak olan eylemlerle ilgili bilgilendirir. Merkezi yönetimi sağlar. Worker node yönetici nodlardan gelen görevleri işlerler. 

Manager node aynı zamanda yeni bir node geldiğinde clustera eklenmesinde mevcut nodun silinmesi ve diğer operasyonları gerçekleştirmeyi sağlar.

Yönetici node kullanıcı isteği doğrultusunda worker node olarak da çalıştırılabilir.

## 2. Worker Node (Yönetici):
Worker node ler Manager Node üzerinden yönetilerek konteynerları çalıştırır. Üzerlerinde bir veya daha fazla container bulundurabilirler. 

[docker-machine](https://github.com/docker/machine)
| Command        | Description |
| -------------- | ----------- |
| `docker swarm`  | docker swarm ile beraber kullanılabilecek komutların bir listesini gösterir.[docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)|

# DOCKER-MACHINE yüklemek kullanabilmek için

docker-machine instalation
<pre>
base=https://github.com/docker/machine/releases/download/v0.16.0 \
  && curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine \
  && sudo mv /tmp/docker-machine /usr/local/bin/docker-machine \
  && chmod +x /usr/local/bin/docker-machine
</pre>

docker-machine kod tamamlama
<pre>
base=https://raw.githubusercontent.com/docker/machine/v0.16.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done
</pre>

`which docker`\
`which docker-compose`\
`which docker-machine`\
`sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose`\
`sudo mv /usr/local/bin/docker-machine /usr/bin/docker-machine`
<hr>


`snap install docker`\
`apt-get update`\
`sudo apt-get install virtualbox`\
`which virtualbox`\
`which VBoxManage`\
`docker-machine create --driver virtualbox swarmManager`\
