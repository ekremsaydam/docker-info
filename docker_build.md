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



>[dockerignore.dockerfile](examDockerFiles/dockerignore.dockerfile)\
`FROM centos`\
`COPY . /home/configfile`

>[.dockerignore](examDockerFiles/.dockerignore)\
`*.txt`\
`*.dockerfile`\
`!*.png`

`docker build -t devcentos -f dockerignore.dockerfile .`\
`docker run -ti devcentos`\
![docker ignore](/img/docker_build_p8.png)

> ## **NOT: Eğer dockerfile dosyası içerisinde yukarıdan aşağıya doğru çalıştırılan komutlar içerisinde çok fazla değişiklik yapılan dosyalara atıf var ise değişiklik yapılan dosyalar, dockerfile dosyasının sonlarına doğru olması docker image build işleminde yaatılan layer ların daha hızlı build işlemine tabi tutulması ve cache üzerinden işlem yapılmasını sağlayacaktır.**
## ORNEK

| Command        | Description |
| -------------- | ----------- |
| `docker build --tag mycentos:v1 .` <br><br> `docker build -t mycentos:v2 .` <br><br>`docker build --tag mycentos:v1 --file mynewcentos .`<br><br>`docker build -t mycentos:v1 -f mynewcentos .`<br><br>`docker build -t gitcentos https://bit.ly/centosDockerfile`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/)|
| `docker image build --tag esaydam/pyapp .`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/) <br><br> ![docker build](/img/docker_build_p9.png)|
| `docker image history esaydam/pyapp:latest`| dockerfile build alıp image oluşturmak için kullanılır. [docker image history](https://docs.docker.com/engine/reference/commandline/image_history/) <br><br> ![docker image history](/img/docker_build_p10.png)|
| `docker image build --tag esaydam/pywebflask --file pyweb.dockerfile .`<br><br>`docker container run --rm --publish 80:8000 -d --name pywebflask esaydam/pywebflask`| [pyweb.dockerfile](/examDockerFiles/pyweb/pyweb.dockerfile) build alıp image oluşturmak için kullanılır. Yaratılan image üzerinden bir container oluturularak docker host üzerindeki 80 portu expose edilir. [docker build](https://docs.docker.com/engine/reference/commandline/build/) |
| `docker image build --tag esaydam/nodejsweb --file nodejs.dockerfile .`<br><br>`docker container run --rm --name nodejsweb -p 8080:8080 -d esaydam/nodejsweb`| [nodejs.dockerfile](/examDockerFiles/nodejsweb/nodejs.dockerfile) build alıp image oluşturmak için kullanılır. Yaratılan image üzerinden bir container oluturularak docker host üzerindeki 80 portu expose edilir. [docker build](https://docs.docker.com/engine/reference/commandline/build/) |
| `docker image build --tag esaydam/hello-docker --file nginx.dockerfile .`<br><br>`docker container run -d --name hellodocker -p 80:80 esaydam/hello-docker`<br><br>`docker container ls`<br><br>`docker ps`| [nginx.dockerfile](/examDockerFiles/helloworldweb/nginx.dockerfile)<br><br>![nginx.dockerfile](/img/docker_dockerfile_example_p1.png)<br><br>![healtcheck](/img/docker_healthcheck_p1.png)<br><br>![nginx.dockerfile](/img/docker_container_run_env_web_p1.1.png) <br><br>![nginx.dockerfile](/img/docker_container_run_env_web_p1.png)|
| `docker container run -d --name hellodocker -p 80:80 --env KULLANICI="newUser" esaydam/hello-docker`| dockerfile kullanılarak yaratılan image için dockerfile içerisinde environment variable değerleri container yaratılırken kullanıldığında override edilir. içerisindeki ![--env](/img/docker_container_run_env_web_p2.png)|



## **NOT: <br>RUN : image oluşturma aşamasında çalışır.<br>CMD : container oluşturma aşamasında çalışır.**

## **NOT: FROM ifadesi ile kullanılan base image oluşturulurken kullanılan environment variable port expose vb. gibi değerler**


<br>
<br>

# KISALTMALAR
| Before         | After       |
| -------------- | ----------- |
|![LABEL](/img/docker_dockerfile_short_p01.png)| ![LABEL short](/img/docker_dockerfile_short_p02.png)|
|![LABEL](/img/docker_dockerfile_short_p03.png)| ![LABEL short](/img/docker_dockerfile_short_p04.png)|
# COPY - ADD FARKI
- COPY, Docker host üzerinden dosya veya klasör kopyalamak için kullanılır.

- ADD, dosya veya klasör kopyalamak için kullanılır. COPY komutundan farkı dosya kaynağı olarak bir URL bilgiside alabilir. 
- ADD ile kaynak olarak docker host üzerinde bulunan bir tar dosyası belirtilir ise bu tar dosyası image içerisine sıkıştırılmış tar haliyle **değil** açılarak kopyalanır. 
[addcmddiff.dockerfile](/examDockerFiles/addcmddiff/addcmddiff.dockerfile) <br> ![add cmd diff](/img/docker_dockerfile_add_cmd_p1.png)
- ADD uzak sunucu üzerinden bir dosya çekecek ise ve tar.gz sıkıştırılmış bir dosya ise bu sefer açma işlemini **yapmaz**.
[addcmddiff.dockerfile](/examDockerFiles/addcmddiff/addcmddiff.dockerfile) <br> ![add cmd diff](/img/docker_dockerfile_add_cmd_p2.png)

# RUN - CMD FARKI
- RUN image oluşturma esnasında çalıştırılır. Birden fazla kez Dockerfile içerisinde kullanılabilirken CMD container oluşturulurken çalışır ve bir kez kullanılabilir.
<br><br>

# CMD -ENTRYPOINT FARKI
- Dockerfile hazırlarken mutlaka CMD veya ENTRYPOINT talimatı bulunmalıdır. Her iki talimatta Dockerfile ile oluşturulan imajdan container oluşturulmaya çalışıldığında çalışacak uygulamayı belirtmemizi sağlar. \
[cmd.dockerfile](/examDockerFiles/entrypointcmd/cmd.dockerfile) <br> ![docker_dockerfile_entrypoint_cmd](/img/docker_dockerfile_entrypoint_cmd_p1.png)\
[entrypoint.dockerfile](/examDockerFiles/entrypointcmd/entrypoint.dockerfile) <br> ![docker_dockerfile_entrypoint_cmd](/img/docker_dockerfile_entrypoint_cmd_p2.png)


- ENTRYPOINT ile girilen komut container oluşturulurken değiştirilemez. CMD ile yazılan komut container oluşturulurken değiştirilebilir. \
[cmd.dockerfile](/examDockerFiles/entrypointcmd/cmd.dockerfile) <br> ![docker_dockerfile_entrypoint_cmd](/img/docker_dockerfile_entrypoint_cmd_p3.png)\
[entrypoint.dockerfile](/examDockerFiles/entrypointcmd/entrypoint.dockerfile) <br> ![docker_dockerfile_entrypoint_cmd](/img/docker_dockerfile_entrypoint_cmd_p4.png)

- ENTRYPOINT ve CMD aynı anda kullanılırsa CMD de yazılan talimat ENTRYPOINT ile yazılan talimatın parametresi olarak çalışır. CMD container oluşturulurken değiştirilebildiği için ENTRYPOINT ile yazılan komutun parametreleri container oluşturulurken değiştirilebilir.
Örneğin birden fazla versiyonu barındıran bir imajın içerisindeki uygulamanın container oluşturulurken istenilen versiyon ile başlatılması sağlanabilir. \
[cmd_entrypoint.dockerfile](/examDockerFiles/entrypointcmd/cmd_entrypoint.dockerfile) <br> ![docker_dockerfile_entrypoint_cmd](/img/docker_dockerfile_entrypoint_cmd_p5.png)

# CMD için EXEC FORM ve SHELL FORM AYRIMI
| Kullanım       | Adı       |
| -------------- | ----------- |
|`CMD uygulama parametre`|SHELL FORM|
|`CMD ["uygulama","parametre"]`|EXEC FORM|

1. image oluşturulurken Dockerfile içerisinde CMD SHELL FORM kullanılarak bir uygulama çalıştırılacak ise oluşturulan container içerisineki PID 1 bu shell process olacaktır.
![CMD SHELL FROM](/img/docker_dockerfile_cmd_exec_shell_p3.png)

2. image oluşturulurken Dockerfile içerisinde CMD EXEC FORM kullanılarak bir uygulama çalıştırılacak ise oluşturulan container içerisineki PID 1 direkt bu komut olacaktır.
![CMD SHELL FROM](/img/docker_dockerfile_cmd_exec_shell_p3.png)

3. CMD EXEC FORM kullanılarak oluşturulmuş Dockerfile içerisinde çalıştırılan CMD satırında çalıştırılan komutun parametrelerinde ENV(Environment Variables) gibi değerlere(değişkenlere) erişilemez.\
[cmdexecform.dockerfile](/examDockerFiles/cmdexecshell/cmdexecform.dockerfile) \
[cmdshellform.dockerfile](/examDockerFiles/cmdexecshell/cmdshellform.dockerfile)
![CMD EXEC FROM](/img/docker_dockerfile_cmd_exec_shell_p1.png) \
![CMD SHELL FROM](/img/docker_dockerfile_cmd_exec_shell_p2.png)

4. ENTRYPOINT ve CMD birlikte kullanılacaksa CMD EXEC FORM kullanılmalıdır. CMD SHELL FORM kullanıldığında ENTRYPOINT e parametre olarak aktarılamaz.
<br><br>
# MULTI-STAGE BUILD
Dockerfile içerisinde bazı nedenlerden dolayı birden fazla FROM ifaesi kullanılabilir. <br><br>
Örneğin yazmış oldumuz java programı için build alınacak bir container ayrı olarak kullanılıp build alınıp sonrasında production ortamına build alınmış halinin dosyaları kopyalanarak ayrı bir container üzerinden hizmet sağlayabilir.

[javajdk.dockerfile](/examDockerFiles/multistagebuild/javajdk.dockerfile)\
`docker image build --tag esaydam/javaappjdk --file javajdk.dockerfile .`\
`docker container run --name javaappjdk esaydam/javaappjdk`

![multi stage build](/img/docker_dockerfile_multistagebuild_p1.png)
`docker container cp javaappjdk:/usr/src/app/app.class .`
[javajre.dockerfile](/examDockerFiles/multistagebuild/javajre.dockerfile)\
`docker image build --tag esaydam/javaappjre --file javajre.dockerfile .`\
![multi stage build](/img/docker_dockerfile_multistagebuild_p2.png)

`docker container run --rm esaydam/javaappjre`
[multistagebuild.dockerfile](/examDockerFiles/multistagebuild/multistagebuild.dockerfile)\
`docker image build --tag esaydam/javaappmultistage --file multistagebuild.dockerfile .`

![multi stage build](/img/docker_dockerfile_multistagebuild_p3.png)