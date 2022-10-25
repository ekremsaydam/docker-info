# [DOCKER SWARM](https://docs.docker.com/engine/reference/commandline/swarm/) - [Getting started with swarm mode](https://docs.docker.com/engine/swarm/swarm-tutorial/)

[Glossary - Docker Sözlük](https://docs.docker.com/glossary/)

Swarm orchestration; docker hostların bir cluster (küme) halinde dağıtımının, yönetiminin ve ölçeklendirilmesinin sağlayan docker engine gömülü bir yapıdır. Yani docker engine yüklendiğinde swarm da kullanılabilir olarak sunuluyor.

Birden fazla sunucuyu tek bir sunucu olarak yönetmemizi sağlıyan, bu yönetimi son derece kolaylaştıran ve güvenlik için işimizi kolaylaştıran özellikler ekleyen, çöken container ları otomatik olarak baştan başlatan, hatta sunucu (node) çökerse onun üzerindeki işleri başka sunucularda otomatik olarak başlatan ve daha birçok özelliği bünyesinde barındıran yönetim aracı diyebiliriz.

Swarm içerisinde her bir docker host **node** olarak adlandırılır. Bu docker host lar sanal yada fiziksel yada cloud üzerinde bir makine olabilir.

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

Container ların üzerinde çalıştığı sunucuların sağlık durumunu izleyerek (HEALTHCHECK) servis kesintisi yaşanması durumunda bunu swarm üyesi diğer node ler üzerinde servisleri ayağa kaldırarak kesinti yaşanmasını engellemektedir.

Rolling Update özelliği sayesinde bir güncelleme olacağı zaman örneğin 10 tane ayakta olan bir service var ise bunların ikişer ikişer güncellenmesini, ve yeni çalışan sürümlerden sonra istediğimiz kadar süre (örneğin 10 dakika) beklemesi ve sağlıklı çalıştığından emin olunca devam etmesi, sağlıklı çalışmıyorsa eski sürüme otomatik olarak geri dönmesi gibi işlemleri kendisi otomarik olarak gerçekleştirebiliyor. Ayrıca Rollback özelliği sayesinde tamamen yeni sürüme geçmiş olsa ve her şey başarılı olsa bile istersek tek bir komutla sistemi eski hakine döndürebiliriz.


Daha fazla bilgi için [Feature highlights](https://docs.docker.com/engine/swarm/#feature-highlights) linkinden yararlanabilirsiniz.

## 1. Manager Node (Yönetici):
Yönetici node lar cluster durumunu kontrol ederek işçi node'leri yapılacak olan eylemlerle ilgili bilgilendirir. Merkezi yönetimi sağlar. Worker node yönetici nodlardan gelen görevleri işlerler. 

Manager node aynı zamanda yeni bir node geldiğinde clustera eklenmesinde mevcut nodun silinmesi ve diğer operasyonları gerçekleştirmeyi sağlar.

Yönetici node kullanıcı isteği doğrultusunda worker node olarak da çalıştırılabilir.

## 2. Worker Node (Yönetici):
Worker node ler Manager Node üzerinden yönetilerek konteynerları çalıştırır. Üzerlerinde bir veya daha fazla container bulundurabilirler. 


Manager ve Worker node ler tüm nodeler kendi aralarında Gossip protokolü ile iletişim kurarlar. Bu iletişim ile kendi içlerinde overlay ağları birbirleri ile paylaşırlar. Paylaşım şifreli olarak GCM modunda AES ile yapılır ve gossip verisini şifreleyen anahtar 12 saate bir otomatk olarak yenilenir. [Encrypt traffic on an overlay network](https://docs.docker.com/network/overlay/#encrypt-traffic-on-an-overlay-network)


## [Raft Consensus Algoritması - Raft consensus in swarm mode](https://docs.docker.com/engine/swarm/raft/)
- Hight Availability sağlanabilmesi yani yüksek erişilebilirliğin sağlanabilmesi için swarm cluster içerisinde birden fazla manager node desteklenir. Manager Node ların herhangi birinde sorun olursa diğer manager node devreye girer ve swarm cluster çalışmaya ve service yönetimi sorunsuz bir şekilde devam eder.
- Swarm Cluster içerisinde Manager Node olarak işaretlenmiş sistemlerden sadece 1 tanesi lider olarak seçilir ve yönetim pasif Manager Node üzerinden değil Lider Manager node üzerinden yapılır. Pasif manager node üzerinde service yaratılmak istense dahi bu Lider manager node iletilir ve onun aracılığı ile işlem gerçekleşir.
- Swarm cluster içerisinde birden fazla manager node olduğu durumda swarm Raft algoritması kullanarak lider seçimi yapılır. Kalan manager nodelar seçim yaparak aralarında lider manager node belirler.
- Raft algoritması (N-1)/2 sayıda node devredışı kalmasını tölere eder.
- Raft algoritmasının ile sorunsuz olarak lider seçiminin yapılabilmesi için tek sayıda (1,3,5,7,9...vb) gibi tek sayıda manager node kurulmuş olması gereklidir. 

[The Raft Consensus Algorithm](https://raft.github.io/)\
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
|`docker swarm init --advertise-addr 192.168.0.24`| Üzerinde komut çaıştırılan node manager node olarak işaretlenmiş olur. [docker swarm init](https://docs.docker.com/engine/reference/commandline/swarm_init/) <br><br> ![docker swarm init](/img/docker_swarm_p2.png)|
|`docker info`| komut docker engine hakkında bilgi verir. docker swarm modunun aktif edilmesinin görüntülenmesi [docker info](https://docs.docker.com/engine/reference/commandline/info/)<br><br> ![docker info](/img/docker_swarm_p3.png)|
|`docker swarm join-token manager`| komut **manager** node eklemek için gerekli komutun ne olduğu gösterir. Bu komutu eklemiş olduğumuz manager node üzerinde çalıştırıyoruz. [docker swarm join-token](https://docs.docker.com/engine/reference/commandline/swarm_join-token/) <br><br> ![docker swarm join-token](/img/docker_swarm_p5.png)|
|`docker swarm join --token SWMTKN-1-26afrz41wobj22iyx7vhkwoeiy6q4z9m06hd759ycpcr4o9lqf-cmusve5b2xs9ky9ln4umziwsa 192.168.0.24:2377`| manager node eklemek için docker engine modunda çalışan herhangi bir node gidilir ve komut çalıştırılarak **manager** node olarak işaretlenmesi sağlanır. [docker swarm join](https://docs.docker.com/engine/reference/commandline/swarm_join/) <br><br> ![docker swarm join](/img/docker_swarm_p6.png)|
|`docker swarm join-token worker`| komut **worker** node eklemek için gerekli komutun ne olduğu gösterir. Bu komutu eklemiş olduğumuz manager node üzerinde çalıştırıyoruz. [docker swarm join-token](https://docs.docker.com/engine/reference/commandline/swarm_join-token/) <br><br> ![docker swarm join-token](/img/docker_swarm_p7.png)|
|`docker swarm join --token SWMTKN-1-26afrz41wobj22iyx7vhkwoeiy6q4z9m06hd759ycpcr4o9lqf-0yjoivazmtlbdx97mdakti2zo 192.168.0.24:2377`| Komut diğer node ler arasında da **worker** node olarak çalıştırılacak sistemler üzerinde bu kod çalıştırılır ve o node da worker node olarak işaretlenmiş olur. [docker swarm join](https://docs.docker.com/engine/reference/commandline/swarm_join/)<br><br>![docker swarm join](/img/docker_swarm_p4.png)|
|`docker node ls`| docker swarm cluster kaç node oluştuğu ve hangilerinin manager olduğunu gösterir.[docker node ls](https://docs.docker.com/engine/reference/commandline/node_ls/)<br><br>![docker node ls](/img/docker_swarm_p8.png)|
|`docker node ps devopsvm`| Belirtilen node üzerinde hangi işlemlerin gerçekleştiğini yönetici node üzerinde çalıştırarak elde edebiliriz. |
|`docker node rm -f devopsvm`| Belirtilen node üzerinde hangi işlemlerin gerçekleştiğini yönetici node üzerinde çalıştırarak elde edebiliriz. |
|`docker node inspect manager1`| docker swarm üzerindeki node ler hakkında bilgi alamk için kullanılır.. Bu komut manager node üzerinde çalıştırılmalıdır. [docker node promote](https://docs.docker.com/engine/reference/commandline/node_inspect/)|
|`docker node inspect --pretty devopsvm`| docker swarm üzerindeki node ler hakkında bilgi alamk için kullanılır.. Bu komut manager node üzerinde çalıştırılmalıdır. --pretty daha güzel bir grünüm sağlar. [docker node promote](https://docs.docker.com/engine/reference/commandline/node_inspect/)|
|`docker node demote manager1`| docker swarm manager node olarak tanımlanmış bir sistemi worker node olarak güncellenmesini sağlar.Bu komut manager node üzerinde çalıştırılmalıdır. [docker node demote](https://docs.docker.com/engine/reference/commandline/node_demote/)|
|`docker node promote worker1`| docker swarm worker node olarak tanımlanmış bir sistemi manager node olarak güncellenmesini sağlar. Bu komut manager node üzerinde çalıştırılmalıdır. [docker node promote](https://docs.docker.com/engine/reference/commandline/node_promote/) ![](/img/docker_node_promote_p1.png)|
|`docker node update --role manager worker1`| docker swarm worker node olarak tanımlanmış bir sistemi manager node olarak güncellenmesini sağlar. Bu komut manager node üzerinde çalıştırılmalıdır. [docker node update](https://docs.docker.com/engine/reference/commandline/node_update/) ![docker node update](/img/docker_node_p2.png)|
|`docker node update --availability drain worker1`| docker swarm içerisinde çalışan ve active bir nodu drain moduna alarak docker swarm cluster dan geçici olarak ayırmak çin kullanılır. Bu komut manager node üzerinde çalıştırılmalıdır. <br>![](/img/docker_node_p3.png)<br>Bu özellik genellikle troubleshoot gerektiren durumlarda kullanılmaktadır. Normal şartlarda aktif durumda olan bir node, service güncelleme ölçeklendirme gibi işlemleri yapmak için drain moda alınır.<br><br> **node drain durumuna alındığında örnekte worker node üzerindeki iş yükünü çalışan diğer nodelere dağıtacak ve yeni service isteklerini karşılamayacaktır.** <br><br> NOT: pause durumuna alınan node üzerinde çalışan service var ise bu o service üzerinde çalışmaya devam eder. ancak yeni bir service isteklerine karşılık vermeyecektir. [docker node update](https://docs.docker.com/engine/reference/commandline/node_update/) ![docker node update](/img/docker_node_p3.png) |
|`docker service ls`| docker swarm modunda yaratılan service lerin listesini gösterir. [docker service ls](https://docs.docker.com/engine/reference/commandline/service_ls/)|
|`docker service create --name test nginx`| Yeni bir service yaratmak için kullanılır. Swarm modda service engine modunda container a karşılık gelmektedir. [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/)|
|`docker service create --name web -p 80:80 --constraint "node.role==worker" --replicas=2 nginx`| Sadece worker node ler üzerinde yeni bir service yaratmak için kullanılır. [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/) ![docker service create](/img/docker_swarm_p26.png) <br> docker-compose dosyasında örnek kullanımı [docker-compose-contraint.yml](/docker-compose/dockerstack/docker-compose-contraint.yml)|
|`docker node update --label-add type=web devopsvm`| belirtilen node bir label vermek için kullanılır. |
|`docker service create --name website -p 80:80 --constraint "node.labels.type==web" nginx`| label ismi olarak belirtilen node lere nginx kurulumunu gerçekleştirir. |
|`docker service ps test`| Belirtilen service hangi nodlar üzerinde çalışıyor onlar görüntülenmektedir. [docker service ps](https://docs.docker.com/engine/reference/commandline/service_ps/)|
|`docker service inspect test`| service hakkında detaylı bilgi gösterir.JSON formatında gösterir. Bu gösterim Desired state olarak adlandırılır ve Node ler üzerinde olması gerekenler üzerinde JSON dosyaları eşitlenene kadar işlemler yapılmaya devam ettirilir. [docker service inspect](https://docs.docker.com/engine/reference/commandline/service_inspect/)|
|`docker service logs test`| Service altında oluşturulan containerların tamamının loglarının gösterilmesini sağlar. [docker service logs](https://docs.docker.com/engine/reference/commandline/service_logs/)|
|`docker service scale test=3`| **ölçekleme** - Önceden sadece 1 tane service varken şimdi 3 tane olarak değiştirdi. Scale in tersi içinde geçerlidir. 2 yada 1 e düşürülebilir. [docker service scale](https://docs.docker.com/engine/reference/commandline/service_scale/)|
|`docker service rm test`| Swarm modunda iken service silmek için kullanılır. [docker service rm](https://docs.docker.com/engine/reference/commandline/service_rm/)|
|`docker service create --name gib --mode global nginx`| Global modda swarma dahil olan manager ve worker node lerın üzerinde istenilen image yi service olarak bütün node ler üzerinde çalıştırır. [ocker service create](https://docs.docker.com/engine/reference/commandline/service_create/)<br><br> ![Global mod](/img/docker_swarm_p13.png)|
| `docker service create --name svcnginx --replicas=5 -p 8080:80 nginx`  | docker swarm cluster üzerindeki MANAGER NODE olarak işaretlenmiş lider node ye nginx imajından 5 tane ismi svcnginx olan worker nodeler üzerinde service yaratılması için kullanılır.[ocker service create](https://docs.docker.com/engine/reference/commandline/service_create/)<br>![docker swarm join](/img/docker_swarm_p9.png)|
| `docker service ls` | docker swarm manager lider node üzerinde yaratılmış service lerin listesini verir. [docker service ls](https://docs.docker.com/engine/reference/commandline/service_ls/)<br>![docker swarm join](/img/docker_swarm_p10.png)|
| `docker service ps svcnginx` | docker swarm manager lider node üzerinde yaratılmış service lerin listesini verir. [docker service ps](https://docs.docker.com/engine/reference/commandline/service_ps/)<br><br> ![docker swarm join](/img/docker_swarm_p11.png)<br> Eğer node lardan herhangi birinde sorun olursa otomatik olarak LEADER MANAGER NODE aktif node ler üzerinde gerekli service yi ayağa kaldırır. ![docker swarm join](/img/docker_swarm_p12.png)|

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

* Aynı overlay network üzerinde bulunan service ler birbirlerini service isimleri (service name) üzerinde iletişim sağlarlar. Docker bu şekilde DNS hizmeti sunmaktadır. Ayrıca load balancing hizmetide docker tarafından yönetilir.

* Overlay networkler üzerinde çalıştırılan serviceler için port publish yapılabilmektedir. Docker swarm overlay network üzerinde routing mesh destekler. [Use swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/). Yani port publish edilip dışarıdaki bir kullanıcı olarak docker host üzerindeki o porta erişirseniz docker swarm modunda yaratılmış service lerin altındaki containerlar üzerine trafiği yönlendirecektir.
* Docker swarm modu aktif edilmiş bir sistemde yeni docker swarm üzerinden yaratılan service ler herhangi bir ağ belirtilmez ise varsayılan olarak otomatik ingress adındaki ağa bağlı olarak yaratılır.
* Her uygulama için ayrı ayrı docker swarm üzerinden overlay network yaratmak uygulamaları ayırmak için önemlidir.
## HAZIRLIK
[phpweb.dockerfile](/examDockerFiles/overlaynetwork/phpweb.dockerfile)

`docker image build --tag esaydam/phpweb --file phpweb.dockerfile .`

esaydam/phpweb image si hazırlanarak hub.docker.com üzerindeki repository ypush edilmiştir.

| Command        | Description |
| -------------- | ----------- |
| `docker network create --driver overlay over-net`  | Bir adet overlay network oluşturmak için kullanılır. [docker network create](https://docs.docker.com/engine/reference/commandline/network_create/) <br>[docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)|
| `docker service create --name web --network over-net --publish 8080:80 --replicas 3 esaydam/phpweb`  | docker manager node üzerinde komutu çalıştırarak php:8.0-apache kurulumunu docker swarm nodları üzerinde over-net isimli network e dahil olacak şekilde 3 replica olarak yarattık. [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/)<br>[docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)|
| `docker service ls`  | docker swarm üzerinde servislerin listesini gösterir. [docker service ls](https://docs.docker.com/engine/reference/commandline/service_ls/)<br> [docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)|
| `docker service ps web`  | Belirtilen service (web) için çalıştırılan görevleri(task) listeler.) [docker service ps](https://docs.docker.com/engine/reference/commandline/service_ps/)<br> [docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/) <br> ![docker service ps](/img/docker_swarm_p15.png) <br> Resimde görüldüğü gibi manager1 üzerinde herhangi bir docker container çalışmamasına rağmen manager1 ip adresi üzerinden 80 portuna erişmek istediğimizde de docker swarm ın yönettiği manager1 üzerinde bir service olmamasına rağmen yinede web sitesi görüntülenecektir. Bu duruma swarm routing mesh denilmektedir.  [Use swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/)|
| `docker service create --name db --network over-net -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql:8.0.31-debian`  | mysql imajından yararlanılarak db isminde ve over-net networküne dahil edilecek şekilde docker swarm üzerinde 1 replicas olacak şekilde bir service oluşturulması için kullanılır. [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/)|
| `docker service inspect web` (yada)<br> `docker service inspect --format '{{json .Endpoint.VirtualIPs}}' web \| jq` <br><br> `docker service inspect db` (yada) <br> `docker service inspect --format '{{json .Endpoint.VirtualIPs}}' db \| jq` | VIP ip adresi kullanımı kontrol edilmesi. [docker service inspect](https://docs.docker.com/engine/reference/commandline/service_inspect/) \|[--format](https://docs.docker.com/config/formatting/#json)\|[--format example](https://docs.docker.com/engine/reference/commandline/inspect/#examples)\|[--formar network](https://docs.docker.com/engine/reference/commandline/network_ls/#formatting) <br>![Docker swarm](/img/docker_swarm_p17.png)|
| `docker service ls` <br><br> `docker service ps db` <br><br> `docker container ls` <br><br> `docker container exec -it 5c522ce6d056 bash` <br><br> `apt-get update && apt-get install -y iputils-ping dnsutils net-tools curl `<br><br>`ping web` <br><br> `dig web` <br><br>`nslookup web`<br><br>`wget -O- web\|more` | Aynı overlay network içerisindeki service lerin birbirleri arasındaki iletişim isim üzerinden yapılabilir. Yandaki komutların hepsi `db` service üzerinden çalıştırılmıştır. ![docker swarm](/img/docker_swarm_p16.png)<br>![docker swarm](/img/docker_swarm_p18.png)<br>![docker swarm](/img/docker_swarm_p19.png)<br>![docker swarm](/img/docker_swarm_p20.png)<br>![docker swarm](/img/docker_swarm_p21.png)|


# DOCKER NETWORK LOAD BALANCER (ROUND ROBIN)
| Command        | Description |
| -------------- | ----------- |
| `curl http://web`  | docker swarm içerisinde `db` service üzerinde çalıştırılan komut. Docker swarm üzerinde Replicas olarak 3 service olduğundan her istek farklı bir service üzerinden cevaplanacak şekilde docker swarm basit bir load balancer hizmetide sunmaktadır. ![docker network balancer](/img/docker_swarm_network_load_balancer_p1.png)<br>![docker network balancer](/img/docker_swarm_network_load_balancer_p2.png)<br>![docker network balancer](/img/docker_swarm_network_load_balancer_p3.png)|


# DOCKER UPDATE AND ROLLBACK
[phpwebversion.dockerfile](/examDockerFiles/dockerserviceupdateroolback/phpwebversion.dockerfile)

`docker image build --tag esaydam/phpweb:v1 --file phpwebversion.dockerfile --build-arg VERSION="V1" .`

`docker image build --tag esaydam/phpweb:v2 --file phpwebversion.dockerfile --build-arg VERSION="V2" .`

`docker image build --tag esaydam/phpweb --file phpwebversion.dockerfile .`

Yukarıdaki komutlar çalıştırılıp hub.docker.com üzerindeki repositıry ye push edilmiştir.

| Command        | Description |
| -------------- | ----------- |
|`docker network create --driver overlay overnet`|overlay network oluşturmak. [docker network create](https://docs.docker.com/engine/reference/commandline/network_create/)|
|`docker service create --name websrv --publish 80:80 --replicas=10 --network overnet esaydam/phpweb:v1` <br><br>`docker service ls`<br><br>`docker service ps websrv`|phpweb:v1 imagesi kullanılarak docker swarm üzerinde 10 replicas olacak şekilde overnet networküne ait service oluşturuldu. [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/) <br> ![docker service create](/img/docker_swarm_p22.png)|
|`docker service update --help`| Update ile ilgili kullanılabilecek opsiyonları gösterir. Update işlevi Mevcut container yada service üzerinde bir değişiklik yapmaz. Yeni bir container oluşturur. İlk önce varolan containerı siler sonrasında yeni image üzerinden yeni container oluşturur. Bunuda aynı anda bütün containerları silerek değil adım adım ilk containerı siler sonrasında yenisini oluşturarak yaparve bu şekilde erişilebilirlik kesintiye uğramadan web sunucuları hizmet vermeye devam edecektir. [docker service update](https://docs.docker.com/engine/reference/commandline/service_update/)|
|`docker service update --update-delay 10s --update-parallelism 2 --image esaydam/phpweb:v2 websrv` <br>`docker service update --update-delay 10s --update-parallelism 2 --image esaydam/phpweb:v2 --detach websrv` <br><br>`watch docker service ps websrv`| websrv servisini aynı anda 2 container olacak şekilde 10 saniye aralıklarla image lerini update etmek için kullanılır. [docker service update](https://docs.docker.com/engine/reference/commandline/service_update/)<br>![docker service update](/img/docker_swarm_p23.png) <br><br> Eğer istenirse `--detach` kullanılarak tekrar shell ekranına düşürülmesi sağlanır. İzlemek için ise `watch` komutundan yararlanılabilir.|
|`docker service rollback  websrv`<br>`docker service rollback --detach websrv`<br><br>`watch docker service ps websrv`|Update işlemi başarısız olursa sistemi bir önceki versiyona geri yüklemek için kullanılır. [docker service rollback](https://docs.docker.com/engine/reference/commandline/service_rollback/)<br>![docker service rollback](/img/docker_swarm_p25.png)|

# EXTRAS
`sshpass -p "parola" scp -P 22 Dockerfile root@172.17.0.2:/ ` \
scp ile ssh üzerinden dosya kopyalama. sshpass şifre sormasını istemediğimiz için pass geçmesini sağlamak adına komut satırından kullanımı.

## DOCKER SWARM VISUALIZE
[visualizer](https://hub.docker.com/r/dockersamples/visualizer)

    docker service create \
    --name=viz \
    --publish=8080:8080/tcp \
    --constraint=node.role==manager \
    --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    dockersamples/visualizer

![docker_swarm_visualize](/img/docker_swarm_visualize_p01.png)

## ARAŞTIRMA KONUSU

`export DOCKER_TLS_VERIFY="1" `\
Uzaktaki makinaya bağlanırken  TLS doğrulaması sırasında sertifika doğrulanmaz ise bağlantı kurulmayacağını belirtir. Bu sayede bağlantının güvenliği için önlem alınmış olur.

`export DOCKER_HOST="tcp://192.168.49.2:2376"` \
tcp protocol ü ile belirtilen ip üzerine docker daemon varsayılan portu 2376 kullandığı için bu port üzerinden bağlantı yapılacağı bildirilir.

`export DOCKER_CERT_PATH="/home/devops/.minikube/certs"` \
TLS doğrulaması yapılabilmesi için kullanılacak sertifikaların path bilgisi gösteriliyor.

`export DOCKER_MACHINE_NAME="minikube"` \
Makinenin ismi veriliyor.

