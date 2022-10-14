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

![docker swarm ports](/img/swarm_diagram_p2.png)
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

[The Raft Consensus Algorithm](https://raft.github.io/)
[Distributed Consensus with Raft - CodeConf 2016](https://www.youtube.com/watch?v=RHDP_KCrjUc)


# [DOCKER SWARM SERVICE](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/)

![docker service diagram](/img/services_diagram_p1.png) \

iki tip service modeli bulunmaktadır. [Replicated and global services](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#replicated-and-global-services)
1. replicated mod
2. global mod
docker swarm declarative olarak çalışan bir uygulamadır ve herhangi bir şey belirtilmez ise replicated modda çalışır.

- Araştırma Konusu Declarative vs imperative
- İkinclik araştırma konusu desired state - Current state

[Swarm mode key concepts](https://docs.docker.com/engine/swarm/key-concepts/)



# [Swarm mode CLI commands](https://docs.docker.com/engine/swarm/#swarm-mode-cli-commands)

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
|`docker service ls`| docker swarm modunda yaratılan service lerin listesini gösterir.|
|`docker service create --name test nginx`| Yeni bir service yaratmak için kullanılır. Swarm modda service engine modunda container a karşılık gelmektedir.|
|`docker service ps test`| Belirtilen service hangi nodlar üzerinde çalışıyor onlar görüntülenmektedir.|
|`docker service inspect test`| service hakkında detaylı bilgi gösterir.JSON formatında gösterir. Bu gösterim Desired state olarak adlandırılır ve Node ler üzerinde olması gerekenler üzerinde JSON dosyaları eşitlenene kadar işlemler yapılmaya devam ettirilir.|
|`docker service logs test`| Service altında oluşturulan containerların tamamının loglarının gösterilmesini sağlar.|
|`docker service scale test=3`| Önceden sadece 1 tane service varken şimdi 3 tane olarak değiştirdi. Scale in tersi içinde geçerlidir. 2 yada 1 e düşürülebilir.|
|`docker service rm test`| Swarm modunda iken service silmek için kullanılır.|
|`docker service create --name gib --mode global nginx`| Global modda swarma dahil olan manager ve worker node lerın üzerinde istenilen image yi service olarak bütün node ler üzerinde çalıştırır. <br><br> ![Global mod](/img/docker_swarm_p13.png)|
| `docker service create --name svcnginx --replicas=5 -p 8080:80 nginx`  | docker swarm cluster üzerindeki MANAGER NODE olarak işaretlenmiş lider node ye nginx imajından 5 tane ismi svcnginx olan worker nodeler üzerinde service yaratılması için kullanılır.![docker swarm join](/img/docker_swarm_p9.png)|
| `docker service ls` | docker swarm manager lider node üzerinde yaratılmış service lerin listesini verir. ![docker swarm join](/img/docker_swarm_p10.png)|
| `docker service ps svcnginx` | docker swarm manager lider node üzerinde yaratılmış service lerin listesini verir.<br><br> ![docker swarm join](/img/docker_swarm_p11.png)<br> Eğer node lardan herhangi birinde sorun olursa otomatik olarak LEADER MANAGER NODE aktif node ler üzerinde gerekli service yi ayağa kaldırır. ![docker swarm join](/img/docker_swarm_p12.png)|

## NOT: 
## 1. MANAGER NODE lar arasında da lider olan node vardır. Eğer komutlar MANAGER NODE olarak eklenmiş ancak lider node olmayan sistem üzerinde çalıştırılırsa SWARM CLUSTER içerisindeki lider node komut gönderilir ve onun çalıştırılması sağlanır.
## 2. Varsayılan olarak MANAGER NODE larda birer WORKER NODE olarak işlem yapar. Ancak Product ortamında MANAGER NODE sadece Swarm cluster sisteminin yönetiminden sorulu tutulacak şekilde sınırlandırılır.
<br><br>
# DOCKER SWARM OVERLAY NETWORK

[Docker Networking](https://www.youtube.com/watch?v=2vcLgcH_hDI)<br>
![docker swarm overlay network](/img/docker_overlay_networking.png)<br>
![docker swarm overlay network](/img/docker_swarm_overlay_network_p2.jpg)<br>

## [Manage swarm service networks](https://docs.docker.com/engine/swarm/networking/#key-network-concepts)
* Swarm Moduna geçildiği zaman otomatik olarak **ingress** adında otomatik overlay network oluşturulur. bu overlay network kullanıcı isteğine göre de oluşturulabilir. Ayrıca yeni docker swarm üzerinde oluşturulan service ler otomatik olarak bu network e bağlanır.
![docker swarm network](/img/docker_swarm_p14.png)

* Ancak overlay network haberleşmesi varsayılan encrypted değildir. Eğer yaratılan bir swarm networkünün encrypted olarak çalışmasını istiyorsanız `--opt encrypted` ifadesi kullanılarak encrypted olması sağlanabilir. Ancak overlay network ün encrypted olması beraberinde yavaşlamayıda getirir.

* overlay network'e bağlı service leri oluşturan containerları birbirleri ile haberleşmesinde herhangi bir port kısıtlaması yoktur ve sanki aynı ağdaymuş gibi çalışırlar.

* Aynı overlay network üzerinde bulunan service ler birbirlerini service isimleri ile iletişimi service name üzerinde olabilmektedir. Docker bu şekilde DNS hizmeti sunmaktadır. Ayrıca load balancing hizmetide docker tarafından yönetilir.

* Overlay networkler üzerinde çalıştırılan serviceler için port publish yapılabilmektedir. Docker swarm overlay network üzerinde routing mesh destekler. [Use swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/). Yani port publish edilip dışarıdaki bir kullanıcı olarak docker host üzerindeki o porta erişirseniz docker swarm modunda yaratılmış service lerin altındaki containerlar üzerine trafiği yönlendirecektir.

| Command        | Description |
| -------------- | ----------- |
| `docker network create --driver overlay over-net`  | Bir adet overlay network oluşturmak için kullanılır. [docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)|
