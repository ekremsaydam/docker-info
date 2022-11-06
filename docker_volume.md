# DOCKER STORAGE

Bu zamana kadar containerları çalıştırdık, işlem yaptık, durdurduk ve sildik. İhtiyacımız olduğunda tekrar container yaratarak çalışır hale getirdik. Ancak daha önce kullandığımız veriler container tekrar yaratılıp ayağa kalktığında silinmekte ve baştan tekrar verilerin girilmesi yada oluşturulması gerekecektir.

Burada iki kavram ortaya çıkmaktadır. **Stateful** ve **Stateless**.

Kendine istek geldiğinde önceki isteklerle ilgili herhangi bir işlem yapmıyor ve gelen isteğe göre sonuç veriyor ise **stateless** ancak önceki istekler gelen istek üzerinde etkisi oluyorsa **stateful** olarak isimlendiriliyor.

Örneğin yarattığımız bir API gelen istekte bulunan değere göre matematiksel işlem yaparak değer döndürüyor ise **stateless** ancak gelen istek daha önce gönderilen isteklerin ortalamasını hesaplayıp gönderilmesini istiyorsa önceki isteklere bağımlı olacağından **stateful** olarak adlandırılır.

Container çalışırken bir nedenden dolayı container kapanmış ve tekrar çalıştırılamıyor olabilir. Bu durumda tekrar container Dockerfile veya docker-compose.yml dosyası yardımıyla oluşturulur ancak verilerimiz artık yeni oluşturulan container içerisinde olmayacaktır. 

**Docker üzerindeki bazı dosyaları container içerisinde değil de docker host üzerinde barındırıyor olsak ne kadar güzel olurdu değil mi!?**

**Yada çeşitli teknolojilerden yararlanarak Docker container içerisine SSHFS kullanarak başka bir bilgisayardaki dosyaları docker container içerisinde istediğimiz yere bağlayabilseydik ne de güzel olurdu!?**

## DOCKER VOLUME
Docker storage denilence VOLUME kavramı ortaya çıkıyor. Container içerisinde saklanacak dosyalar volume adı verilen bölümler içerisinde saklanabiliyor. 

Docker host üzerinde bu bölümler `/var/lib/docker/volumes/` path içerisinde yeni bir folder yaratılarak container içerisine bu folder bağnakarak (mount) işlemi ile gerçekleştiriliyor.

Docker host üzerinde yaratılan volume leri görüntülemek için `docker volume ls` komutu kullanılmaktadır.

Volume çeşitler : 
- Anonymous Volume
- Named Volume
- Bind Volume


Yeni bir volume yaratılacak ise `docker volume create volume_ismi` komutundan yararlnabiliriz. [docker volume create](https://docs.docker.com/engine/reference/commandline/volume_create/) \
![docker volume create](/img/docker_volume_p3.png)

`docker container run --name volume-test --volume sqlite-files:/sqlite -ti alpine`

Komutu ile bir container yaratılırken ( [docker container run](https://docs.docker.com/engine/reference/commandline/container_run/) ) daha önce yarattığımız volume bağlama işlemini `--volume` veya `-v` parametresi ile verebiliyoruz. 

![docker volume create](/img/docker_volume_p4.png) 

Bu oluşturulan dosya Docker host üzerinde bulunduğu yere baktığımızda\
`docker container run --name volume-test --volume sqlite-files:/sqlite -ti alpine` \
![](/img/docker_volume_p5.png)

gördüğünüz gibi docker host üzerinden de erişilebilir. Dikkat ederseniz root kullanıcısı ile erişebileceğimizi görebilirsiniz.

[Add bind mounts or volumes using the --mount flag](https://docs.docker.com/engine/reference/commandline/run/#add-bind-mounts-or-volumes-using-the---mount-flag)
Ayrıca --volume ile yaptığımızı --mount ile de yapabiliriz. Aralarındaki fark `--mount` docker swarm ile uyumludur. Ayrıca --mount parametresinde key=value şeklinde yazıldığında ve aralarında , (virgül) kullanıldığın dikkat edin. 

`docker container run --name volume-test --mount source=sqlite-files,destination=/sqlite -ti alpine` \
veya \
`docker container run --name volume-test --mount src=sqlite-files,dst=/sqlite -ti alpine` \
veya \
`docker container run --rm --name volume-test --mount type=volume,src=sqlite-files,dst=/sqlite -ti alpine`\
kullanılabilir.
![docker container run --mount](/img/docker_volume_p6.png)

## DOCKER BIND MOUNT YONTEMI
Yazılım geliştirme esnasında docker container üzerine klasör bağlamak isteyebiliriz. Bind Mount yöntemi ile bunu yapabiliriz.

--volume veya -v parametresi ile kullanılabilir.
[app.py](/examDockerFiles/pycodes/app.py) \
`docker container run --rm -v $PWD/codes:/codes python:3 python3 /codes/app.py` \
![bind mount](/img/docker_volume_p7.png)

`--mount` parametresi ile de kullanılabilir.

`docker run --rm --mount type=bind,src=$PWD/codes,dst=/codes python:3 python3 /codes/app.py` \
![bind mount](/img/docker_volume_p8.png)

## [tmpfs YONTEMI](https://docs.docker.com/storage/tmpfs/#use-a-tmpfs-mount-in-a-container)

Çalışan container içerisinde saklamak istemeyeceğimiz dosyalar olabilir. Bu durumda olan verileri diske yazmak yerine RAM üzerinde tutarak oradan container a bağlama yapabiliyoruz. 

Yukarıda açıklanan nedenlerin yanında bazende hız gerektiren durumlar olabiliyor. Bu gibi durumlarda da diske yazmak yerine RAM üzerinde yazma-silme işlemleri işlemleri yaparak hız kazanabiliriz.

`docker run -it --mount type=tmpfs,dst=/temp alpine` \
![tmpfs](/img/docker_volume_p9.png)

Burada dikkat edilmesi gerekn konu tmpfs ile oluşturulan bölümün dosya boyutu sınırının bulunmamasıdır yani varsayılan boyutu yoktur. 

`tmpfs-size` ile boyut ve `tmpfs-mode` ilede izin sınırını verebileceğiniz iki paremetresi bulunmaktadır.

![](/img/docker_volume_p10.png)

container silindiği anda yada durdurulup tekrar çalıştırıldığında RAM üzerinden bilgiler silineceği için yada birisi sunucuyu söküp gitse tekrar containerı çalıştırsa dahi buradaki bilgilere ulaşamayacaktır.

## [DOCKER EKLENTİLERİ (PLUGIN)](https://docs.docker.com/engine/extend/)
Docker üzerindeki eklentileri görmek için : `docker plugin ls` kullanılır. \
## SSHFS ÖRNEĞİ
ssh üzerinden farklı konumdaki bir sunucu üzerine dosya aktarılmasını sağlamak için SSHFS eklentisi kullanılır. \
SSHFS ile bir container üzerinden işlem yapabilmek için docker eklentisinin yüklenmesi gerekmektedir.

`docker plugin install vieux/sshfs` \
![](/img/docker_volume_p11.png)

Eklenti silmek istersek `docker plugin rm` kullanılmaktadır.
<br><br>

[Dockerfile](/docker-compose/ssh/Dockerfile) \
`docker image build --tag openssh-server .` \
`docker run -p 2200:22 --name dosyasunucusu -d openssh-server` \
`docker container ls` \
`docker port dosyasunucusu` \
![docker plugin](/img/docker_plugins_drivers_p2.png) \
`docker container inspect dosyasunucusu` \
![docker plugin](/img/docker_plugins_drivers_p3.png) \
`ssh root@localhost -p 2200` \
![docker plugin](/img/docker_plugins_drivers_p1.png) 
<hr>

`docker volume create --driver vieux/sshfs -o sshcmd=root@172.17.0.2 -o password=parola depo` \
`docker volume ls` \
![docker plugin](/img/docker_plugins_drivers_p4.png) 

    docker volume create \
        -d vieux/sshfs \
        --name sshvolume \
        -o sshcmd=root@172.17.0.2:/remote \
        -o password=parola

`docker run --rm -v sshvolume:/sshvolume -ti alpine` \
![docker plugin](/img/docker_plugins_drivers_p5.png) \

ssh sunucusu üzerine exec ile bağlandığımızda remote klasörünü kontrol ettiğimizde aynı dosyanında oradan ulaşılabilir olduğu görüntülenecektir. \
`docker container exec -it dosyasunucusu bash` \
![docker plugin](/img/docker_plugins_drivers_p6.png)

CTRL+D : terminal işlemini sonlandırarak işlem yapar. \
CTRL+P+Q: terminal işlemini sonlandır**ma**dan çıkış yapar. Arka planda çalışmaya devam eder.

# ÇALIŞAN CONTAINER İÇERİSİNE ve İÇERİSİNDEN VERİ AKTARIMI

Eğer container oluştururuken bir VOLUME bağlamadı ise ve anlık olarak çalışan container içerisinden dosya almak yada sistemimizden container içerisine bir dosya göndermek istediğimizde nasılyapabiliriz?

## [docker cp](https://docs.docker.com/engine/reference/commandline/cp/) veya [docker container cp](https://docs.docker.com/engine/reference/commandline/container_cp/)

`docker run --name DEV -ti alpine` 

aşağıdaki komutu container içerisinde çalıştırıyoruz. \
`dd if=/dev/zero of=bosdosya bs=10M count=1` \
![docker container cp](/img/docker_container_cp_p01.png) 


Aşağıdaki koutları container dışında docker host üzerinde iken çalıştırıyoruz.\
`docker cp DEV:/bosdosya .` \
`docker cp gonderilen DEV:/gonderilen` \
![docker container cp](/img/docker_container_cp_p02.png) \