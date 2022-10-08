# DOCKERFILE 
[dockerfile](https://docs.docker.com/engine/reference/builder/) \
İmajlar **dockerfile** adı verilen özel yapılar ile oluşturulur. Dockerfile Docker'a özgü bir betik dosyasıdır.
`docker build` kullanılarak dockerfile içerisindeki talimatları yürüterek bir imaj oluşturur. [docker build](https://docs.docker.com/engine/reference/commandline/build/) | [docker image build](https://docs.docker.com/engine/reference/commandline/image_build/)

Sözdizimi \
`docker build [OPTIONS] PATH | URL | -`

## [FROM](https://docs.docker.com/engine/reference/builder/#from)
Hangi imajın temel olarak kabul edileceğini gösterir. TAG yazılırken : kullanılır. Eğer kullanılmaz ise latest kabul edilir. Tek bir dockerfile içerisinde birden fazla FROM kullanılabilir.

### [ARG](https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact)
ARG ve FROM nasıl etkileşim içerisindedir. ARG FROM ifadesinin önüne gelerek bir değişten içerisine değer atama işlemini sağlar ve sonrasında FROM satırında değişken kullanımı sağlanmış olur.

## [RUN](https://docs.docker.com/engine/reference/builder/#run)
**imajların oluşumu** sırasında belirtilen komutları çaıştırır.
İki farklı formu vardır.
1. `RUN <command>`
2. `RUN ["executable", "param1", "param2"]`

İlk formu kullanılacak ise escape `\` karakteri kullanılarak birden fazla satır komut çalıştırılabilir.

**NOT**: *Birden çok satırda RUN kullanmak yerine tek bir satırda RUN ifadesi kullanılması doğru bir yaklaşımdır. Birden fazla satırda RUN ifadesi kullanılması imajın oluşturulduğu katman sayısını artıracaktır.*

İkinci formu kullanılacaksa **çift tırnak** `"` kullanıldığına dikkat edin.

**NOT**: *ikinci formun kullanıldığı noktalarda çift tırnak içerisinde `\` kullanılacak ise `\\` olarak kullanılması gerekmektedir.*

## [CMD](https://docs.docker.com/engine/reference/builder/#cmd)
CMD dockerfile içerisinde sadece 1 kez kullanılabilir. Birden fazla kullanımlarda sadece son kullanılan CMD satırı çalışacaktır.

Bir **konteynerin çalışması sırasında** başlangıç davranışını belirler. 

Üç formu vardır.
1. `CMD ["executable","param1","param2"]`
2. `CMD ["param1","param2"]`
3. `CMD command param1 param2`

docker run komutu ile argüman kullanılırsa CMD ile oluşturulmuş parametrelerin yerine geçer. Bu durumda Dockerfile içerisindeki CMD direktifi yok sayılır.

>[fromrunaddcmd.dockerfile](examDockerFiles\fromrunaddcmd.dockerfile)\
`FROM centos`\
`RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/`<br><br>
`yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && yum update -y && yum install wget git -y` <br><br>
`ADD https://raw.githubusercontent.com/ekremsaydam/docker/master/README.md /home/README.md`\
`CMD tail /home/README.md`

`docker build -t myfirstimage -f fromrunaddcmd.dockerfile .`
![docker build](/img/docker_build_p5.png)

## [ADD](https://docs.docker.com/engine/reference/builder/#add)
İki formu vardır.
1. `ADD [--chown=<user>:<group>] <src>... <dest>`
2. `ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]`

`--chown=` parametresi sadece linux kullanıcıları için geçerlidir.

`src` olarak belirtilen dosyayı image içerisine `dest` olarak belirtilen pathe kopyalar.

**NOT**:*`ADD` komutunun `COPY` komutundan farklı tar dosyaları ve URL üzerinden de işlem yapabilmesidir."*

## [COPY](https://docs.docker.com/engine/reference/builder/#copy)
Docker'ın çalıştığı kaynak makineden oluşturulan image içerisine dosya ve klasör kopyalamayı sağlar.\
Kullanım formu iki tanedir: 
1. `COPY [--chown=<user>:<group>] <src>... <dest>`
2. `COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]`

**NOT**:*`--chown` windows versiyonlarda çalışmaz.*
>[copy.dockerfile](examDockerFiles\copy.dockerfile)\
`FROM centos`\
`COPY README.txt /home/`\
`RUN cat /home/README.txt`\
![docker build](/img/docker_build_p6.png)

## [LABEL](https://docs.docker.com/engine/reference/builder/#label)
image ye metadata ekler. Anahtar değer çiftidir.
Kullanım formu:\
`LABEL <key>=<value> <key>=<value> <key>=<value> ...`

## [MAINTAINER](https://docs.docker.com/engine/reference/builder/#maintainer-deprecated) (kullanımdan kaldırıldı)
Kullanımdan kaldırıldı. Yerine LABEL parametresi kullanılabilir.

Oluşturulan image ler ile ilgli MAINTAINER (yazar) metadata verisi ekler.

## [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose)
Protocol belirtilmez ise TCP olarak varsayılan değeri bulunmaktadır. container çalıştırılırken -p --port parametresi ile hangi portların yayınlanması amaçlandığı belirtilir. 

Kullanım formu:\
`EXPOSE <port> [<port>/<protocol>...]`

> [expose.dockerfile](examDockerFiles\expose.dockerfile)\
`FROM nginx`\
`MAINTAINER Yazar_ismi yazar@root` (kullanımdan kaldırıldı)\
`EXPOSE 80/tcp`


Örnek\
`docker run -d -p 80:80 nginx`

## [ENV](https://docs.docker.com/engine/reference/builder/#env)
container üzerinde çevresel değişenler, ortam değişkenleri ayarlar. Tek bir satırda birden fazla ortam değişkeni ayarlanabilir. key value arasında eşittir `=` işareti kullanılmaz ise tek bir satırda bir ortam değişkeni tanımlanmalıdır.\
Kullanım formu:\
`ENV <key>=<value> ...`

> [env.dockerfile](examDockerFiles\env.dockerfile)\
`FROM centos`\
`ENV user=dockerfileuser password=dockerfilepassword`

`docker build -t envcentos -f env.dockerfile .`\
`docker run -ti -d envcentos`
`docker ps`\
`docker attach ee`\
![docker build](/img/docker_build_p1.png)

## [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)
Yaratılan image çalıştırılacak container olarak ayarlandığında ENTRIPOINT olarak ayarlanmış fonksiyon ile başlatılır.
iki kullanım formu vardır
1. `ENTRYPOINT ["executable", "param1", "param2"]` (exec tipi)
2. `ENTRYPOINT command param1 param2` (shell tipia)

>[entrypoint.dockerfile](examDockerFiles\entrypoint.dockerfile)\
`FROM ubuntu`\
`ENTRYPOINT ["top", "-b"]`\
`CMD ["-c"]`

`docker build -t entubuntu -f entrypoint.dockerfile .`\
`docker run -ti entubuntu`\
![docker build](/img/docker_build_p2.png)

    NOT: Birden fazla ENTRYPOINT satırı var ise en son satır çalışır.
>[entrypoint2.dockerfile](examDockerFiles\entrypoint2.dockerfile)\
`FROM centos`\
`ENTRYPOINT [ "echo","Entrypoint test satir1" ]`\
`ENTRYPOINT [ "echo","Entrypoint test satir2" ]`
![docker build](/img/docker_build_p4.png)


## [USER](https://docs.docker.com/engine/reference/builder/#user)
Dockerfile ile oluşturulan image ler varsayılan olarak root kullanıcı ile çalışır. `USER` komutu başlangıçta hangi kullanıcı ile çalışılacağını belirler. RUN, ENTRYPOINT ve CMD ile belirtilen uygulamalar bu kullanıcı ile çalıştırılır. 
`USER <user>[:<group>]`
`USER <UID>[:<GID>]`

Kullanıcı daha önce varsayılan kullanıcılar arasında yoksa önce kullanıcı oluşturulmalı sonra USER komutunda bu kullanıcı kullanılmalıdır.

windows için
>`FROM microsoft/windowsservercore`\
`# Create Windows user in the container`\
`RUN net user /add patrick`\
`# Set it for subsequent commands`\
`USER patrick`

linux için
>[user.dockerfile](examDockerFiles\user.dockerfile)\
>`FROM centos`\
`RUN adduser newuser`\
`USER newuser`\
`CMD whoami`

![docker build](/img/docker_build_p3.png)

## [WORKDIR](https://docs.docker.com/engine/reference/builder/#workdir)
image oluşturulduktan sonra container çalıştırıldığında başlangıç dizininin hangisi olacağına karar verilmesi için kullanılır.
dockerfile içerisinde WORKDIR ayarlanmamış ise base image tarafından ayarlanmış olarak işlem görecektir.

Kullanım şekli\
`WORKDIR /path/to/workdir`

>[workdir.dockerfile](examDockerFiles\workdir.dockerfile)\
`FROM centos`\
`RUN adduser newuser`\
`WORKDIR /home/`\
`CMD pwd`


`docker build -t workdircentos -f workdir.dockerfile .`\
`docker run -ti workdircentos`

## [VOLUME](https://docs.docker.com/engine/reference/builder/#volume)

Host makine ve konteyner arasında dizin bağlama işlevini yerine getirir.

>[volume.dockerfile](examDockerFiles\volume.dockerfile)\
`FROM ubuntu`\
`RUN mkdir /myvol`\
`RUN echo "hello world" > /myvol/greeting`\
`VOLUME /myvol`

`docker build -t volubuntu -f volume.dockerfile .`\
`devopdocker container run -ti volubuntu`\
![docker build](/img/docker_build_p7.png)

docker çalıştıran sunucu içerisindeki `/var/lib/docker/volumes` yolunda container çalıştırılırken oluşturulan volume id ile açılan klasör içerisinde container ile dosya paylaşmı yapılır.

## [ONBUILD](https://docs.docker.com/engine/reference/builder/#onbuild)

ONBUILD parametresi ile eklenen komutlar eklendiği dockerfile imagesi başka bir image içerisinde kullanıldığında tetiklenerek çalışır.

## [SHELL](https://docs.docker.com/engine/reference/builder/#shell)

Kullanım şekli:\
`SHELL ["executable", "parameters"]`

Varsayılan kabul linux için `["/bin/sh", "-c"]` windows için `["cmd", "/S", "/C"]` dir.

dockerfile içerisinde yazılan birden çok shell talimatları bir öncekini geçersiz kılar.

## [.dockerignore file](https://docs.docker.com/engine/reference/builder/#dockerignore-file)



>[dockerignore.dockerfile](examDockerFiles\dockerignore.dockerfile)\
`FROM centos`\
`COPY . /home/configfile`

>[.dockerignore](examDockerFiles\.dockerignore)\
`*.txt`\
`*.dockerfile`\
`!*.png`

`docker build -t devcentos -f dockerignore.dockerfile .`\
`docker run -ti devcentos`\
![docker ignore](/img/docker_build_p8.png)

## ORNEK

| Command        | Description |
| -------------- | ----------- |
| `docker build --tag mycentos:v1 .` <br><br> `docker build -t mycentos:v2 .` <br><br>`docker build --tag mycentos:v1 --file mynewcentos .`<br><br>`docker build -t mycentos:v1 -f mynewcentos .`<br><br>`docker build -t gitcentos https://bit.ly/centosDockerfile`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/)|
| `docker image build --tag esaydam/pyapp .`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/) <br><br> ![docker build](/img/docker_build_p9.png)|
| `docker image history esaydam/pyapp:latest`| dockerfile build alıp image oluşturmak için kullanılır. [docker image history](https://docs.docker.com/engine/reference/commandline/image_history/) <br><br> ![docker image history](/img/docker_build_p10.png)|

