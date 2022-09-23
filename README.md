# INSTALATION ON LINUX
## 1. SSH Instalation on Ubuntu
>`sudo apt-get update`\
>`sudo apt list --upgradable`\
>`sudo apt-get upgrade`\
>`sudo apt-get dist-upgrade`\
>`sudo apt install openssh-server`\
>`sudo systemctl status ssh`\
![systemctl status ssh komutu sonrasındaki görüntü](/img/docker_install_p1.png)

>`sudo ufw status`\
>`sudo ufw enable`\
>`sudo ufw allow ssh`\
![sudo ufw allow ssh komutu sonrasındaki görüntü](/img/docker_install_p2.png)

>`sudo ufw status`\
![sudo ufw allow ssh komutu sonrasındaki görüntü](/img/docker_install_p6.png)

> `ip address`\
![sudo ufw allow ssh komutu sonrasındaki görüntü](/img/docker_install_p7.png)

> `ssh devops@192.168.100.10` # ssh devops@localhost\
![sudo ufw allow ssh komutu sonrasındaki görüntü](/img/docker_install_p9.png)\
> > `exit`

> `reboot`

>`do-release-upgrade`\
![do-release-upgrade komutu sonrasındaki görüntü](/img/docker_install_p4.png)

> `sudo systemctl stop ssh`

> `sudo systemctl start ssh`

> `sudo systemctl enable ssh` # sudo systemctl disable ssh

![systemctl komutu sonrasındaki görüntü](/img/docker_install_p5.png)

>`sudo apt list --upgradable`\
>`sudo apt-get upgrade`\
>`sudo apt-get dist-upgrade`

## 2. INSTALL DOCKER ENGINE on Ubuntu
[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).\
[Docker Engine release notes](https://docs.docker.com/engine/release-notes/)

1. Eski sürümü aldırmak için kullanılır.\
`sudo apt-get remove docker docker-engine docker.io containerd runc`

2. Apt paketlerini güncelleyiniz.\    
`sudo apt-get update`

3. Gerekli paket kurulumlarını yapınız.\
`sudo apt-get install ca-certificates curl gnupg lsb-release`

4. Docker'ın resmi GPG anahtarını ekleyin\
`sudo mkdir -p /etc/apt/keyrings` \
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`

5. En son kararlı sürümü apt-get ile kurabilme için kullanılmalıdır.\
`echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

6. apt paketlerini güncelleyiniz.\
`sudo apt-get update`

7. Docker engine ve docker containerin son sürümlerini yükleme\
`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin`\
NOT: `apt-cache madison docker-ce` komutu ile Docker Engine'in belirli bir sürümünü yüklemek için depodaki kullanılabilir sürümleri listelemek için kullanılır. `sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io docker-compose-plugin` komutu ile istenilen sürüm yüklenebilir.

8. Docker yüklenip yüklenmediğinin kontrolü \
`docker --version`

9. docker durum bilgisi kontrol edilir.\
`sudo systemctl status docker`

10. docker servisi yeniden başlatılır. \
`sudo service docker start`

11. Paket yükleme\
`sudo apt-get install -y uidmap`

12. Belirli bir kullanıcı ile docker çalıştırma için config yükleme\
`dockerd-rootless-setuptool.sh install`

13. Güvenlik açısından root kullanıcısı yerine farklı bir kullanıcı ile docker kullanılması tercih edilmelidir.\
`sudo usermod -aG docker devops`

14. docker servisi yeniden başlatılır.\
`sudo systemctl restart docker`

15. docker durum bilgisi kontrol edilir.\
`sudo systemctl status docker`

16. Bilgisayar restart edilir.\
`reboot`

# DOCKER IMAGE
Popüler olarak kullanılan birçok uygulamanın resmi imajları kendi üreticisi tarafından [Docker Hub](https://hub.docker.com/search?q=) üzerinde yayınlanmaktadır.

Docker linux yerel imaj deposu:


| Command        | Description |
| -------------- | ----------- |
| `docker info`  | Docker kurulumu ile ilgili sistem genelindeki bilgileri gösterir. [docker info](https://docs.docker.com/engine/reference/commandline/info/)|
| `docker images`  | Yüklü imajları listelemek için kullanılır [docker images](https://docs.docker.com/engine/reference/commandline/images/) |
| `docker image ls`   | Yüklü imajları listelemek için kullanılır.<br> **REPOSITORY:** hangi repodan çekildiği bilgisini gösterir. TAG: imajın versiyonunun gösterir. <br>**IMAGE ID:** her docker için farklı bir kimlik olup 64 karakterden oluşur. İlk 12 karakteri gösterilir. İmajın 12 karakterlik kısmı kullanılarakda işlem yapılabilir. <br>**CREATED:** imajın oluşturulduğu tarihi gösterir.<br>**SIZE:**imajın bıyutunu gösterir. NOT: ID numaraları ile işlem yaparken hızdan tasarruf etmek adına kimlik numarasının benzersiz olan ilk karakterleri kullanılarak da imaj üzerinde işlemyapılabilir. [docker image](https://docs.docker.com/engine/reference/commandline/image/) \|[docker image ls](https://docs.docker.com/engine/reference/commandline/image_ls/)|
| `docker image ls -q` | Yüklü imajların ID numaralarını listelemek için kullanılır. |
| `docker image pull <<image_name>>`  | Docker Hub üzerinde yer alan imajı yerel sisteme çekmek için kullanılır. [docker image pull](https://docs.docker.com/engine/reference/commandline/image_pull/)|
| `docker images \| grep -A2 postgres`  | postgress imajından önce yüklenmiş son 2 image yi gösterir. Toplamda 3 image gösterecektir. |
| `docker images \| grep -B2 postgres`  | postgress imajından sonra yüklenmiş 2 image yi gösterir. Toplamda 3 image gösterecektir. |
| `docker image pull alpine:latest`  | : öncesi repository adını sonra gelen tag bölümü de imaja ait versiyonu göstermektedir. TAG bölümü belirtilmez ise latest kabul edilir. <br> **NOT:** latest ifadesi güncel imajı işaret ettiğini garanti etmez. |
| `docker image pull alpine`  | : öncesi repository adını sonra gelen tag bölümü de imaja ait versiyonu göstermektedir. TAG bölümü belirtilmez ise latest kabul edilir. NOT: latest ifadesi güncel imajı işaret ettiğini garanti etmez. |
| `docker image pull alpine:3`  | : öncesi repository adını sonra gelen tag bölümü de imaja ait versiyonu göstermektedir. |
| `docker image pull alpine -a`  | -a parametresi ile bir imajın bütün versiyonları indirilebilir. |
| `docker image inspect nginx:latest`  | belirtilen imaj ile ilgili ayrıntılı bilgi gösterir. [docker image inspect](https://docs.docker.com/engine/reference/commandline/image_inspect/) |
| `docker image rm nginx:latest`  | imaj_name olarak belirtilen imajı siler. NOT: Bir container a ait imaj silinemez. Öncesinde imajın bağlı bulunan container ın durdurulması gereklidir. [docker image rm](https://docs.docker.com/engine/reference/commandline/image_rm/) |
| `docker rmi alpine:3`  | Belirtilen imajı siler. [docker rmi](https://docs.docker.com/engine/reference/commandline/rmi/) |
| `docker rmi $(docker image ls -q) --force`  | Bütün imajları silmek için kullanılır. [docker rmi](https://docs.docker.com/engine/reference/commandline/rmi/) |
| `docker images --filter "dangling=true"`  | TAG verisi olmayan imajları listelemek için kullanılır. [docker images Filtering](https://docs.docker.com/engine/reference/commandline/images/#filtering) |
| `docker rmi $(docker images -f "dangling=true" -q)`  | TAG verisi olmayan imajları silmek için kullanılır. [docker images Filtering](https://docs.docker.com/engine/reference/commandline/images/#filtering) |
| `docker images --filter label="maintainer"`  | Label olarak verilen key value şeklindeki veriye göre filtreleme yapar. `docker image inspect nginx:latest` ile label isimleri görüntülenebilir. [docker images Filtering](https://docs.docker.com/engine/reference/commandline/images/#filtering) |
| `docker image history nginx:latest`  | Belitilen imaj üzerindeki değişiklikleri boyut bilgisi ile gösterir. [docker image history](https://docs.docker.com/engine/reference/commandline/image_history/) |
| `docker image tag node:latest node-world:v3` | nginx:latest imajından nginx:v1 etiketi ile yeni bir tane oluşturur. [docker image tag](https://docs.docker.com/engine/reference/commandline/image_tag/) |
| `docker images \| grep node-world` | docker imajlarında node+world olarak isimlendirilmiş imajlar gösterilir. [docker image tag](https://docs.docker.com/engine/reference/commandline/image_tag/) |
| `docker image save nginx:latest > nginx_later.tar` | nginx:v2 imajının tar arşivi olarak kaydedilmesini sağlar. [docker image save](https://docs.docker.com/engine/reference/commandline/image_save/) |
| `docker image load --input nginx_later.tar` | Arşiv olarak kaydedilen imajların geri yüklenmesini sağlar. [docker image load](https://docs.docker.com/engine/reference/commandline/image_load/) |
| `docker image prune` | Geçmişe yönelik kullanılmayan imajları silmek için kullanılır. [docker image load](https://docs.docker.com/engine/reference/commandline/image_load/) |
| `docker image prune -a` | Geçmişe yönelik kullanılmayan ve referans verileyen imajları silmek için kullanılır.(-a  --all) [docker image prune](https://docs.docker.com/engine/reference/commandline/image_prune/) |
| `docker image prune -a --force --filter "until=24h"` | Son 24 saate oluşturulmuş imajları siler. [docker image prune](https://docs.docker.com/engine/reference/commandline/image_prune/) |
| `docker login` | Hub.docker.com üzerinde sistemimizin login olması için kullanılır. [docker login](https://docs.docker.com/engine/reference/commandline/login/) |
| `docker image tag alpine:latest esaydam/alpine5:v1`<br><br>`docker tag alpine:latest esaydam/alpine5:v1` | alpine:latest imajını esaydam/alpine5:v1 olarak işaretler. [docker image tag](https://docs.docker.com/engine/reference/commandline/image_tag/) |
| `docker image push esaydam/alpine5:v1`<br><br> `docker push esaydam/alpine5:v1`| Hub.docker.com üzerinde bulunan repository'ye imajı göndermek için kullanılır. [docker image push](https://docs.docker.com/engine/reference/commandline/image_push/) |

# DOCKER CONTAINER
Bir container bir imajın çalışır durumdaki halidir. Bir imajdan birden çok container çalıştırılabilir. 

Sanal makine ile container teknolojisinin fark; sanal makine bir işletim sisteminin bütününü çalıştırırken, container konumlandığı işletim sisteminin çekirdeğini paylaşarak sanal makineye göre daha hızlı çalışacaktır.

| Command        | Description |
| -------------- | ----------- |
| `docker container ls`<br><br>`docker ps`<br><br>`docker container ls -a`<br><br>`docker ps -a`  | Çalışan containerları göstermek için kullanılır. [docker container ls](https://docs.docker.com/engine/reference/commandline/container_ls/)|
| `docker container run alpine:latest ls -a`  | Belirtilen imaj içerisinde ls -a komutunu çalıştırır ve container çalışmasını durdurur. [docker container run](https://docs.docker.com/engine/reference/commandline/container_run/)|
| `docker container run --interactive --tty  centos /bin/bash`<br><br>`docker container run -it centos /bin/bash` <br><br>**`docker run -itd centos /bin/bash`** | **-i --interactive**=> interactive terminal <br> **-t -tty** => TTY pseudo terminal. <br><br>Belirtilen imaj başlatılır ve bash kabuğu üzerinden sanal bir terminal üzerinden etkileşimli bağlantı oluşturulurur. <br> Centos imajı üzerinden bir container ayağa kaldırır ve interaktif bash ile ona bağlanır. <br> **NOT:** <br> - **CTRL+Q+P** tuş kombinasyonu ile çıkış yapılabilir. Bu kombinasyonla çıkış yapılması **containerin çalışmasını durdurmaz.** <br> - Bash kabuğunda çalışırken **exit** komutu ile çıkılabilir. Bu **bash kabuğunun sonlanmasına neden olur**. [docker container run](https://docs.docker.com/engine/reference/commandline/container_run/) ![docker container run](/img/docker_container_p11.png)|
| `docker container stats 33c657b76ca8` | Çalışan Containerın kaynak kullanımını gösterir. [docker container stats](https://docs.docker.com/engine/reference/commandline/container_stats/) |
| `docker container attach 78b324e4e06c`<br><br>`docker attach 78b324e4e06c` | Çalışan container a bağlanılmasını sağlar. [docker container attach](https://docs.docker.com/engine/reference/commandline/container_attach/) ![docker container rm](/img/docker_container_p1.png)|
| `docker container rm ebbfd968b330` <br><br>`docker container rm ebbfd968b330 -f`| container i siler. container silinmesi için durmuş olması gerekir. **-f --force** parametresi ile çalışan kontainer da silinir. [docker container rm](https://docs.docker.com/engine/reference/commandline/container_rm/)|
| `docker container run --interactive --tty --detach centos /bin/bash`<br><br> `docker container run -itd centos /bin/bash`| Konteynerin arka planda çalıştırılmasını sağlar. [docker container run](https://docs.docker.com/engine/reference/commandline/container_run/)|
| `docker container commit 092 new_centos`| Varolan bir container üzerinden yeni bir imaj oluşturur ve yerel olarak images arasına kaydeder.  [docker container commit](https://docs.docker.com/engine/reference/commandline/container_commit/) ![docker container commit](/img/docker_container_p2.png)|
| `docker container cp 092:/liste.txt .` | Belirtilen container içindeki dosyaları bulunulan dizine kopyalar [docker container cp](https://docs.docker.com/engine/reference/commandline/container_cp/) ![docker container cp](/img/docker_container_p3.png)|
| `docker container create centos` | Belirtilen imajdan bir container oluşturur. [docker container create](https://docs.docker.com/engine/reference/commandline/container_create/) <br> **NOT:** Eğer imaj local de yoksa hub.docker.com üzerinden indirir.|
| `docker container diff 36` | Belirtilen container_name dosya sistemi üzerindeki dosyalarda veya klasörlerde yapılan değişiklikleri gösterir. [docker container diff](https://docs.docker.com/engine/reference/commandline/container_diff/) ![docker container cp](/img/docker_container_p4.png)|
| `docker container exec 36 cat /etc/resolv.conf` | Belirtilen containerid si üzerinde bir komut(cat gibi) çalıştırmak için kullanılır. [docker container exec](https://docs.docker.com/engine/reference/commandline/container_exec/) ![docker container exec](/img/docker_container_p5.png)|
| `docker container export 36 --output exportcentos.tar`<br><br>`docker container export 36 -o exportcentos.tar` | Çalışan bir containerı tar dosyası olarak export eder. [docker container export](https://docs.docker.com/engine/reference/commandline/container_export/) |
| `docker container inspect 36` | Çalışan bir container hakkında bilgi verir. [docker container inspect](https://docs.docker.com/engine/reference/commandline/container_inspect/) |
| `docker container kill 36` | Belirtilen container idsini durdurur. [docker container kill](https://docs.docker.com/engine/reference/commandline/container_kill/) ![docker container kill](/img/docker_container_p6.png) |
| `docker container logs 36` | Belirtilen containerın loglarını gösterir. shell ekranındaki kullanılan komutların listesini gösterir.[docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker container ps` <br><br> `docker container ls`| Yerel sistemdeki containerleri listeler. [docker container ls](https://docs.docker.com/engine/reference/commandline/container_ls/) [docker container ps](https://docs.docker.com/engine/reference/commandline/ps/)|
| `docker container pause 7a`| Belirtilen containeri geçici olarak durdurur. [docker container pause](https://docs.docker.com/engine/reference/commandline/container_pause/) |
| `docker container unpause 33c657b76ca8`| Durdururmuş container ı tekrar çalıştırır. [docker container unpause](https://docs.docker.com/engine/reference/commandline/container_unpause/) |
| `docker container restart 7a`| Durdururmuş container ı tekrar çalıştırır. [docker container restart](https://docs.docker.com/engine/reference/commandline/container_restart/) |
| `docker container prune`| Durdurulmuş stop edilmiş (kill komutu ile - pause edilmişleri silmez.) containerleri siler. [docker container prune](https://docs.docker.com/engine/reference/commandline/container_prune/) |
| `docker container rename wonderful_varahamihira c_centos`| Container ismini değiştirir. [docker container rename](https://docs.docker.com/engine/reference/commandline/container_rename/) ![docker container rename](/img/docker_container_p7.png) |
| `docker container stop fa`| Belirtilen containerın çalışmasını durdurur. [docker container stop](https://docs.docker.com/engine/reference/commandline/container_stop/) |
| `docker container stop fa`| Belirtilen containerın çalışmasını durdurur. [docker container stop](https://docs.docker.com/engine/reference/commandline/container_stop/) |
| `docker container ls -a --filter status=exited`| Durdurulmuş konteynerlerin listelenmesini sağlar. [docker container ls](https://docs.docker.com/engine/reference/commandline/container_ls/) |
| `docker container start fa`| Belirtilen durmuş (stop) containerı çalıştırır. [docker container start](https://docs.docker.com/engine/reference/commandline/container_start/) ![docker container start](/img/docker_container_p8.png)|
| `docker container port 660c0b8819d0`| Belirtilen containerın port maping bilgilerini gösterir. [docker container port](https://docs.docker.com/engine/reference/commandline/container_port/) ![docker container port](/img/docker_container_p9.png)|
| `docker container rm 660c0b8819d0 -f`| Belirtilen container veya containerları force (-f) silmeye zorlar. [docker container rm](https://docs.docker.com/engine/reference/commandline/container_rm/) ![docker container rm](/img/docker_container_p10.png)|
| `docker container top 33c657b76ca8`| Belirtilen container için çalışan programları gösterir. [docker container top](https://docs.docker.com/engine/reference/commandline/container_top/) |

# DOCKER CONTAINER KAYNAK KULLANIMI



