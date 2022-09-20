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
| `docker image ls`   | Yüklü imajları listelemek için kullanılır. REPOSITORY: hangi repodan çekildiği bilgisini gösterir. TAG: imajın versiyonunun gösterir. IMAGE ID: her docker için farklı bir kimlik olup 64 karakterden oluşur. İlk 12 karakteri gösterilir. İmajın 12 karakterlik kısmı kullanılarakda işlem yapılabilir. CREATED: imajın oluşturulduğu tarihi gösterir. SIZE: imajın bıyutunu gösterir. NOT: ID numaraları ile işlem yaparken hızdan tasarruf etmek adına kimlik numarasının benzersiz olan ilk karakterleri kullanılarak da imaj üzerinde işlemyapılabilir. [docker image](https://docs.docker.com/engine/reference/commandline/image/) \|[docker image ls](https://docs.docker.com/engine/reference/commandline/image_ls/)|
| `docker image ls -q` | Yüklü imajların ID numaralarını listelemek için kullanılır. |
| `docker image pull <<image_name>>`  | Docker Hub üzerinde yer alan imajı yerel sisteme çekmek için kullanılır. [docker image pull](https://docs.docker.com/engine/reference/commandline/image_pull/)|
| `docker images \| grep -A2 postgres`  | postgress imajından önce yüklenmiş son 2 image yi gösterir. Toplamda 3 image gösterecektir. |
| `docker images \| grep -B2 postgres`  | postgress imajından sonra yüklenmiş 2 image yi gösterir. Toplamda 3 image gösterecektir. |
| `docker image pull alpine:latest`  | : öncesi repository adını sonra gelen tag bölümü de imaja ait versiyonu göstermektedir. TAG bölümü belirtilmez ise latest kabul edilir. NOT: latest ifadesi güncel imajı işaret ettiğini garanti etmez. |
| `docker image pull alpine`  | : öncesi repository adını sonra gelen tag bölümü de imaja ait versiyonu göstermektedir. TAG bölümü belirtilmez ise latest kabul edilir. NOT: latest ifadesi güncel imajı işaret ettiğini garanti etmez. |
| `docker image pull alpine:3`  | : öncesi repository adını sonra gelen tag bölümü de imaja ait versiyonu göstermektedir. |
| `docker image pull alpine -a`  | -a parametresi ile bir imajın bütün versiyonları indirilebilir. |
| `docker image inspect nginx:latest`  | belirtilen imaj ile ilgili ayrıntılı bilgi gösterir. [docker image inspect](https://docs.docker.com/engine/reference/commandline/image_inspect/) |
| `docker image rm nginx:latest`  | imaj_name olarak belirtilen imajı siler. NOT: Bir container a ait imaj silinemez. Öncesinde imajın bağlı bulunan container ın durdurulması gereklidir. [docker image rm](https://docs.docker.com/engine/reference/commandline/image_rm/) |
| `docker rmi alpine:3`  | Belirtilen imajı siler. [docker rmi](https://docs.docker.com/engine/reference/commandline/rmi/) |
| `docker rmi $(docker image ls -q) --force`  | Bütün imajları silmek için kullanılır. [docker rmi](https://docs.docker.com/engine/reference/commandline/rmi/) |