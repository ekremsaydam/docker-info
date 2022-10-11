# [DOCKER SWARM](https://docs.docker.com/engine/reference/commandline/swarm/) - [Getting started with swarm mode](https://docs.docker.com/engine/swarm/swarm-tutorial/)
Swarm orchestration; docker hostların bir cluster (küme) halinde dağıtımının, yönetiminin ve ölçeklendirilmesinin sağlayan docker engine gömülü bir yapıdır. Yani docker engin yüklendiğinde swarm da kullanılabilir olarak sunuluyor.

Swarm içerisinde her bir docker host node olarak adlandırılır. Bu docker host lar sanal yada fiziksel yada cloud üzerinde bir makine olabilir.

Swarm üzerindeki node lar birbirleri arasında ağ yapısı üzerinden iletişim kurabilirler.

İki tip Node vardır.
1. Manager (Yönetici)
2. Worker (işçi)

Swarm üzerinde worker node üzerinde container ları çalıştıran yapılara services denir.

Swarm için ayrı bir kuruluma gerek yoktur.

Ayıca swarm üzerindeki makinelerin (node) haberleşmesi için gerekli **PORT** bulunmaktadır.
**[Open protocols and ports between the hosts](https://docs.docker.com/engine/swarm/swarm-tutorial/#open-protocols-and-ports-between-the-hosts)**
![docker swarm ports](/img/docker_swarm_p1.png)
<hr>

## 1. Manager Node (Yönetici):
Yönetici node lar cluster durumunu kontrol ederek işçi node'leri yapılacak olan eylemlerle ilgili bilgilendirir. Merkezi yönetimi sağlar. Worker node yönetici nodlardan gelen görevleri işlerler. 

Manager node aynı zamanda yeni bir node geldiğinde clustera eklenmesinde mevcut nodun silinmesi ve diğer operasyonları gerçekleştirmeyi sağlar.

Yönetici node kullanıcı isteği doğrultusunda worker node olarak da çalıştırılabilir.

## 2. Worker Node (Yönetici):
Worker node ler Manager Node üzerinden yönetilerek konteynerları çalıştırır. Üzerlerinde bir veya daha fazla container bulundurabilirler. 


## Raft Consensus Algoritması
- Availability sağlanabilmesi yani yüksek erişilebilirliğin sağlanabilmesi için swarm cluster içerisinde birden fazla manager node desteklenir. Manager Node ların herhangi birinde sorun olursa diğer manager node devreye girer ve swarm cluster çalışmaya ve service yönetimi sorunsuz bir şekilde devam eder.
- Swarm Cluster içerisinde Manager Node olarak işaretlenmiş sistemlerden sadece 1 tanesi lider olarak seçilir ve yönetim pasif Manager Node üzerinden değil Lider Manager node üzerinden yapılır. Pasif manager node üzerinde service yaratılmak istense dahi bu Lider manager node iletilir ve onun aracılığı ile işlem gerçekleşir.
- Swarm cluster içerisinde birden fazla manager node olduğu durumda swarm Raft algoritması kullanarak lider seçimi yapılır. Kalan manager nodelar seçim yaparak aralarında lider manager node belirler.
- Raft algoritması (N-1)/2 sayıda node devredışı kalmasını tölere eder.
- Raft algoritmasının ile sorunsuz olarak lider seçiminin yapılabilmesi için tek sayıda (1,3,5,7,9...vb) gibi tek sayıda manager node kurulmuş olması gereklidir. 

[docker-machine](https://github.com/docker/machine)

| Command        | Description |
| -------------- | ----------- |
| `docker swarm`  | docker swarm ile beraber kullanılabilecek komutların bir listesini gösterir.[docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)|
|`docker swarm init --advertise-addr 192.168.0.24`| Üzerinde komut çaıştırılan node manager node olarak işaretlenmiş olur. <br><br> ![docker swarm init ](/img/docker_swarm_p2.png)|
|`docker info`| komut docker hakkında bilgi verir. docker swarm modunun aktif edilmesinin görüntülenmesi <br><br> ![docker swarm init ](/img/docker_swarm_p3.png)|
|`docker swarm join-token manager`| komut **manager** node eklemek için gerekli komutun ne olduğu gösterir. Bu komutu eklemiş olduğumuz manager node üzerinde çalıştırıyoruz. <br><br> ![docker swarm init ](/img/docker_swarm_p5.png)|
|`docker swarm join --token SWMTKN-1-26afrz41wobj22iyx7vhkwoeiy6q4z9m06hd759ycpcr4o9lqf-cmusve5b2xs9ky9ln4umziwsa 192.168.0.24:2377`| manager node eklemek için docker engine modunda çalışan herhangi bir node gidilir ve komut çalıştırılarak **manager** node olarak işaretlenmesi sağlanır. <br><br> ![docker swarm init ](/img/docker_swarm_p6.png)|
|`docker swarm join-token worker`| komut **worker** node eklemek için gerekli komutun ne olduğu gösterir. Bu komutu eklemiş olduğumuz manager node üzerinde çalıştırıyoruz. <br><br> ![docker swarm init ](/img/docker_swarm_p7.png)|
|`docker swarm join --token SWMTKN-1-26afrz41wobj22iyx7vhkwoeiy6q4z9m06hd759ycpcr4o9lqf-0yjoivazmtlbdx97mdakti2zo 192.168.0.24:2377`| Komut diğer node ler arasında da **worker** node olarak çalıştırılacak sistemler üzerinde bu kod çalıştırılır ve o node da worker node olarak işaretlenmiş olur.<br><br>![docker swarm join](/img/docker_swarm_p4.png)|
|`docker node ls`| docker swarm cluster kaç node oluştuğu ve hangilerinin manager olduğunu gösterir.<br><br>![docker swarm join](/img/docker_swarm_p8.png)|

## NOT: 
## 1. MANAGER NODE lar arasında da lider olan node vardır. Eğer komutlar MANAGER NODE olarak eklenmiş ancak lider node olmayan sistem üzerinde çalıştırılırsa SWARM CLUSTER içerisindeki lider node komut gönderilir ve onun çalıştırılması sağlanır.
## 2. Varsayılan olarak MANAGER NODE larda birer WORKER NODE olarak işlem yapar. Ancak Product ortamında MANAGER NODE sadece Swarm cluster sisteminin yönetiminden sorulu tutulacak şekilde sınırlandırılır.


| Command        | Description |
| -------------- | ----------- |
| `docker service create --name svcnginx --replicas=5 -p 8080:80 nginx`  | docker swarm cluster üzerindeki MANAGER NODE olarak işaretlenmiş lider node ye nginx imajından 5 tane ismi svcnginx olan worker nodeler üzerinde service yaratılması için kullanılır.![docker swarm join](/img/docker_swarm_p9.png)|
| `docker service ls` | docker swarm manager lider node üzerinde yaratılmış service lerin listesini verir. ![docker swarm join](/img/docker_swarm_p10.png)|
| `docker service ps svcnginx` | docker swarm manager lider node üzerinde yaratılmış service lerin listesini verir.<br><br> ![docker swarm join](/img/docker_swarm_p11.png)<br> Eğer node lardan herhangi birinde sorun olursa otomatik olarak LEADER MANAGER NODE aktif node ler üzerinde gerekli service yi ayağa kaldırır. ![docker swarm join](/img/docker_swarm_p12.png)|
