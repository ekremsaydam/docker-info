# DOCKERFILE 
[dockerfile](https://docs.docker.com/engine/reference/builder/) \
İmajlar **dockerfile** adı verilen özel yapılar ile oluşturulur. Dockerfile Docker'a özgü bir betik dosyasıdır. imagenin tanımlamalarının yapıldığı dosyadır. Her satırda belli bir direktif (instruction) bulunmaktadır. Her direktif de image nin bir katmanını oluşturur. Her direktif kendisinden önceki katman üzerinde çalışır ve değişiklikler yeni bir katmanda tutulur. Kısacası kaç satırınız var ise o kadar katmanınız vardır diyebiliriz.

`docker build` kullanılarak dockerfile içerisindeki talimatları yürüterek bir imaj oluşturur. [docker build](https://docs.docker.com/engine/reference/commandline/build/) | [docker image build](https://docs.docker.com/engine/reference/commandline/image_build/)

Sözdizimi \
`docker build [OPTIONS] PATH | URL | -`

`docker build` çalıştırıldığında Dockerfile'ın bulunduğu klasör (path - yol) içerisindeki dosyalar Docker Daemon aracılığı ile image dönüştürülür. Bu path içerisindeki dosyalar ve alt klasörlerin tamamına `context` denilmektedir.

[Dockerfile](/examDockerFiles/contextsample/Dockerfile) \
image oluşturulmak istendiğinde context Docker üzerine aktarılır.\
`dd if=/dev/zero of=bosdosya bs=10M count=1`
![](/img/dockerfile_p01.png)

.dockerignore dosyası kullanılarak context içerisindeki dosyaların Docker Daemon a iletilmesinin önüne geçilmiş olur. Dosyalarımızı proje içerisinde tutup context boyutunu bu şekilde artırılmamasını sağlıyoruz.

![](/img/dockerfile_p02.png)

Kritik bilgilerin tutulduğu dosyalaro, test aşamasında üretilmiş log dosyalarını, verileri, prola dosyalarını context dışında tutarak işlem yapılmasını `.dockerignore` dosyası ile sağlamış oluyoruz.

Ayrıca github üzerinde bulunan bir Dockerfile üzerinde de build alınarak bir image oluşturulabilir. \
`docker build -t gitrepoimage https://raw.githubusercontent.com/ekremsaydam/docker-info/master/examDockerFiles/cowsay/Dockerfile`
## NOT: Güvenlik açısından projelerinizin github repolarında Dockerfile bulundurulmaması önerilmektedir.

Yorum satırları için satır başına # ifadesi kullanılır.

## [FROM](https://docs.docker.com/engine/reference/builder/#from)
Hangi imajın temel olarak kabul edileceğini gösterir. Bu noktada en temel imajın ne olduğu konusu ortaya çıkıyor. Dockerfile içerisinde FROM ifadesi yer almayan yada `FROM scratch` image lere base image denilmektedir.

scratch image docker içerisinde var olan boş image ye verilen isimdir. En temelde bu image yi baz alarak kendi imagelerimizi oluşturabiliriz.

Docker file içerisinde `FROM scratch` ifadesini yazsak bile `docker pull` ile kendi sistemimize çekmemiz veya `docker container run` ile çalıştırmamız olanaklı olmamaktadır.

![](/img/docker_image_base_p1.png)

FROM ile beraber kullanılan image lere parent image (ebeveyn) denilmektedir.

TAG yazılırken : kullanılır. Eğer kullanılmaz ise latest kabul edilir. Tek bir dockerfile içerisinde birden fazla FROM kullanılabilir. 

## [RUN](https://docs.docker.com/engine/reference/builder/#run)

**imajların oluşumu** sırasında bir önceki katman üzerinde çalıştırılacak komutları yazmak için kullanılır.

İki farklı formu vardır.
1. SHELL FORMATI : `RUN <command>`
2. EXEC FORMATI : `RUN ["executable", "param1", "param2"]`

İlk formu kullanılacak ise escape `\` karakteri kullanılarak birden fazla satır komut çalıştırılabilir.

**NOT**: *Birden çok satırda RUN kullanmak yerine tek bir satırda RUN ifadesi kullanılması doğru bir yaklaşımdır. Birden fazla satırda RUN ifadesi kullanılması imajın oluşturulduğu katman sayısını artıracaktır.*

İkinci formu kullanılacaksa **çift tırnak** `"` kullanıldığına dikkat edin.

**NOT**: *ikinci formun kullanıldığı noktalarda çift tırnak içerisinde `\` kullanılacak ise `\\` olarak kullanılması gerekmektedir.*


## [CMD](https://docs.docker.com/engine/reference/builder/#cmd)
Bir container oluşturulmak istendiğinde `docker container run ubuntu calistirilacak_komut` kullanılarak `calistirilacak_komut` ifadesi ile herhangi bir komut belirtilmediği taktirde varsayılan olarak container başlatıldığında işletilmesini istediğimiz komutun belirlenmesi için kullanılır.

`docker run` komutu kullanılarak çalışması istenilen komut belirtilirse CMD satırı görmezden gelinir. Bu durumda Dockerfile içerisindeki CMD direktifi yok sayılır.

CMD dockerfile içerisinde sadece 1 kez kullanılabilir. Birden fazla kullanımlarda sadece son kullanılan CMD satırı çalışacaktır.

CMD bir **konteynerin çalışması sırasında** başlangıç davranışını belirler. 

Üç formu vardır.
1. `CMD ["executable","param1","param2"]`
2. `CMD command param1 param2`
3. `CMD ["param1","param2"]`

>[fromrunaddcmd.dockerfile](examDockerFiles\fromrunaddcmd.dockerfile)\
`FROM centos`\
`RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/`<br><br>
`yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && yum update -y && yum install wget git -y` <br><br>
`ADD https://raw.githubusercontent.com/ekremsaydam/docker/master/README.md /home/README.md`\
`CMD tail /home/README.md`

`docker build -t myfirstimage -f fromrunaddcmd.dockerfile .`
![docker build](/img/docker_build_p5.png)

Farklı bir örrnek Dockerfile içeriği:

    FROM alpine
    RUN apk add --no-cache python3
    CMD python3 -m http.server 9000
`docker image build --tag pyweb:v3 .` \
`docker container run --rm --name pyweb -p 9000:9000 -d esaydam/pyweb:v3` \

### [ARG](https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact)
ARG ve FROM nasıl etkileşim içerisindedir. ARG FROM ifadesinin önüne gelerek bir değişten içerisine değer atama işlemini sağlar ve sonrasında FROM satırında değişken kullanımı sağlanmış olur.
[Dockerfile](/examDockerFiles/arg/Dockerfile) \
`docker image build --tag pythoncustom:v2 .` \
`docker container run --rm pythoncustom:v2` \


`docker image build --tag pythoncustom:v3 --build-arg PYTHON_VERSION="3" --build-arg CYTHON_VERSION="3.0.0a11" .` \
`docker container run --rm pythoncustom:v3` \

![docker container run](/img/dockerfile_p04.png)
### NOT: ARG kullanımında dikkat edilmesi gereken, kullanıcı adı ve şifre gibi anahtar bilgileri Dockerfile a koymak yerine `--build-arg` ile parametre olarak vermek mantıklı geliyorsa da, yaratılan image üzerinden docker image history çalıştıran birisi tüm ARG değerlerini görebilir. Bu yüzden kullanıcı adı/parola gibi değişkenleri image argüman olarak vermek iyi bir yöntem değildir.

![docker container run](/img/dockerfile_p10.png)

## [ADD](https://docs.docker.com/engine/reference/builder/#add)
Container içerisine dosya kopyalamak için kullanılır. 
İki formu vardır.
1. `ADD [--chown=<user>:<group>] <src>... <dest>`
2. `ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]`

`--chown=` parametresi sadece linux kullanıcıları için geçerlidir.

`src` olarak belirtilen dosyayı image içerisine `dest` olarak belirtilen path e kopyalar.

**NOT**:*`ADD` komutunun `COPY` komutundan farklı tar dosyaları ve URL üzerinden de işlem yapabilmesidir."*

Eğer kopyalanacak dosya tar ise container içerisinde tar dosyası açılarak atılır. Ancak URL üzerinden tar dosyası alınacak ise o zaman açma işlemini yerine getirmez. \
[Dockerfile](/examDockerFiles/add/Dockerfile)\
`docker image build --tag pyapp:v3 .`\
`docker container run --rm pyapp:v3`
![Dockerfile](/img/dockerfile_p03.png)

## [COPY](https://docs.docker.com/engine/reference/builder/#copy)
Docker'ın çalıştığı kaynak makineden oluşturulan image içerisine dosya ve klasör kopyalamayı sağlar. \
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
oluşturulan image için belirtmek istediğimiz etiketler, tanımlamalar eklemek için kullanılır. `docker image inspect` komutu ile LABEL görüntülenebilir.
image ye metadata ekler. Anahtar değer çiftidir.
Kullanım formu:\
`LABEL <key>=<value> <key>=<value> <key>=<value> ...`

[Dockerfile](/examDockerFiles/label/Dockerfile) \
Genellikle `maintainer` olara belirtilen image bakımını yapan kişinin bilgileri bulunur. 

`docker image build --tag customcentos .` \
`docker image inspect customcentos:latest` \
![docker image build](/img/docker_build_p11.png)

## [MAINTAINER](https://docs.docker.com/engine/reference/builder/#maintainer-deprecated) (kullanımdan kaldırıldı)
Kullanımdan kaldırıldı. Yerine LABEL parametresi kullanılabilir.

Oluşturulan image ler ile ilgli MAINTAINER (yazar) metadata verisi ekler.

## [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose)
Container içerisinde çalışan uygulama bir veya daha fazla portu dinlemeye başlar. Hangi portların dinlendiğini belirtmek için kullanılır. 

Kullanım formu:\
`EXPOSE <port> [<port>/<protocol>...]` \

Protocol belirtilmez ise TCP olarak varsayılan değeri bulunmaktadır.

Dockerfile içerisinde yanlızca EXPOSE kullanımı dış dünyaya portu direkt olarak açmaz. Docker a image üzerinden container oluşturulduğunda hangi portların açılması gerektiğini bildirir. 

Birden fazla port yazılacak ise yan yana aralarında boşluk bırakarak yazılabilir.

`EXPOSE 80/tcp 53/udp`

container çalıştırılırken -p --port parametresi ile hangi portların yayınlanması amaçlandığı belirtilir. 

`docker container run --name pywebv4 -p 80:9000 -d pyweb:v4` \
![](/img/docker_container_p16.png)

-P parametresi kullanılarak EXPOSE ile bildirilen porta dış dünyadan 30000 üzerindeki bir portla otomatijk eşleştirilmesi sağlanır.

`docker container run --name pywebv4 -P -d pyweb:v4` \
![docker container run](/img/docker_container_p15.png)

> [expose.dockerfile](examDockerFiles\expose.dockerfile)\
`FROM nginx`\
`MAINTAINER Yazar_ismi yazar@root` (kullanımdan kaldırıldı)\
`EXPOSE 80/tcp`


Örnek\
`docker run -d -p 80:80 nginx` 

## [ENV](https://docs.docker.com/engine/reference/builder/#env)
container üzerinde çevresel değişenleri, ortam değişkenlerini ayarlar. Tek bir satırda birden fazla ortam değişkeni ayarlanabilir. key value arasında eşittir `=` işareti kullanılmaz ise tek bir satırda bir ortam değişkeni tanımlanmalıdır.\
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

ENV ayrıca `docker container run` veya `docker run` komutu ile beraber `-e` yada `--env` parametresi ile de belirtilebilir. `-e`,`--env` parametresi ile Dockerfile içerisinde yazan değeri ezer ve komut satırından belirtilen ortam değişkenleri baskın olacaktır.

## [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)
Yaratılan image çalıştırılacak container olarak ayarlandığında ENTRIPOINT olarak ayarlanmış fonksiyon ile başlatılır.
iki kullanım formu vardır
1. EXEC FORMU: \
`ENTRYPOINT ["executable", "param1", "param2"]`
2. SHELL FPRMU : \
`ENTRYPOINT command param1 param2` \
Shell formu kullanıldığında CMD direktifi ve `docker container run` komutu üzerinden verilen image isminden sonra yazılan değer dikkate alınmaz. Alınması isdeniyorsa exec formu kullanılmalıdır.

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

[Namespace](/linux_namespace.md) içerisinde geçerli olan UID (User ID) ve GID(grup ID) değerlerini değiştirmeyi saplar. Dockerfile ile oluşturulan image root kullanıcısı olarak başlatılır. Ardından sistemi bir kullanıcı ekleyerek ve o kullanıcı hesabı ile işlemlerimize (RUN, ENTRYPOINT, CMD) devam edeceğimizi belirmek için USER ifadesi kullanılıyor.

windows için
>`FROM microsoft/windowsservercore`\
`# Create Windows user in the container`\
`RUN net user /add patrick`\
`# Set it for subsequent commands`\
`USER patrick`

linux için
>[user.dockerfile](examDockerFiles\user.dockerfile)\
>`FROM centos`\
`RUN useradd newuser`\
`USER newuser`\
`CMD whoami`

![docker build](/img/docker_build_p3.png)

## [WORKDIR](https://docs.docker.com/engine/reference/builder/#workdir)
image oluşturulduktan sonra container çalıştırıldığında başlangıç dizininin hangisi olacağına karar verilmesi için kullanılır.
dockerfile içerisinde WORKDIR ayarlanmamış ise base image tarafından ayarlanmış olarak işlem görecektir.

Kullanım şekli\
`WORKDIR /path/to/workdir`

Dockerfile içerisinde WORKDIR satırından sonra gelen işlemler, direktifler (RUN,ENTRYPOINT,CMD) ve image içerisine dosya eklemeye yarayan komutlar (ADD,COPY) WORKDIR ile belirtilen dizin üzerinde işlem yaparlar. `pwd` komutu ile bu öğrenilebilir. Kısacası relative path olarak işlem görecektir.

>[workdir.dockerfile](examDockerFiles\workdir.dockerfile)\
`FROM centos`\
`RUN adduser newuser`\
`WORKDIR /home/`\
`CMD pwd`

`docker build -t workdircentos -f workdir.dockerfile .`\
`docker run -ti workdircentos`

## [VOLUME](https://docs.docker.com/engine/reference/builder/#volume)
Çalışacak olan image üzerinde kalıcı olması gereken dosyalar olabilir. Veritabanı dosyaları, web sunucusu içerisinde statik dosyalar, ayar dosyalarının bulunduğu dizinler VOLUME ile docker a bildirilir.

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

Bulunduğu Dockerfile ile oluşturulan image ler üzerinde bir değişikliğe neden olmaz. ONBUILD ile yazılan direktiflerin çalışabilmesi için oluşturulan image üzerinden base alınarak tekrar bir image oluşturulması şarttır.\
[Dockerfile](/examDockerFiles/onbuild/Dockerfile) \
![Dockerfile](/img/dockerfile_p05.png)
`docker image build --tag baseimage .` \
`docker container run --rm baseimage` \
Herhangi bir çıktı alınmaz.

`docker image build --file base.Dockerfile --tag baseimage:v2 .` \
![Dockerfile](/img/dockerfile_p07.png) \
`docker container run --rm baseimage:v2` \
![Dockerfile](/img/dockerfile_p06.png)


## [SHELL](https://docs.docker.com/engine/reference/builder/#shell)

Kullanım şekli:\
`SHELL ["executable", "parameters"]`

Varsayılan kabul linux için `["/bin/sh", "-c"]` windows için `["cmd", "/S", "/C"]` dir.

dockerfile içerisinde yazılan birden çok shell talimatları bir öncekini geçersiz kılar.
## [STOPSIGNAL](https://docs.docker.com/engine/reference/builder/#stopsignal)
Container i durdurmak istediğimizde ona hangi sinyalin gideceğini belirtmemize yarar.

[Dockerfile](/examDockerFiles/pywebv3/Dockerfile) \
`docker image build --tag stopexam .` \
`docker container run -d stopexam sleep 3000` \
`docker container ls` \
`docker container stop 74f1839f1697`

Docker file içerisinde `STOPSIGNAL SIGHUP` kullanıldığında container hemen sonlanmaz. O an varolan işlemi sonuçlandırana kadar çalışmaya devam eder. Ancak bu arda yeni bir iş geldiğinde onu başlatmaz ve güvenli bir şekilde sonlandırır. 

Ancak `STOPSIGNAL SIGKILL` deyimi direkt container ı sonlandırmak için kullanılır. Veri kaybına neden olabilir.

## [HEALTCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck)
Container ın o anda sağlıklı çalışıp çalışmadığını kontrol etmek için kullanılır. \
[Dockerfile](/examDockerFiles/pywebserponse/Dockerfile) \
`docker image build --tag pythonweb .` \
`docker container run --rm -p 80:80 pythonweb` \
`docker container run --rm --name api -d -p 80:80 -e WAIT_TIME=2 pythonweb` \
`watch docker ps` \
![HEALTCHECK](/img/dockerfile_p09.png)

Dockerfile içerisindeki \
`HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://127.0.0.1:80/number || exit 1` \
bu direktif 30 saniye aralıklarla CMD teriminden sonraki komutu çalıştırıyor. Zaman aşımı 30 saniye olarak belirtilmiştir. 3 Kez başarısız olursa container UNHEALTY (sağlıksız) olarak işaretleniyor. İlk açılış işlemleri belirli bir süre alacağı için bu kontrolü belirli bir zaman yapmamak için `--start-period` olarak 5 sayine verilmiş durumda. 

`watch docker ps` ile docker üzerindeki bütün containerların çalışan uygulamaları izlenebilmektedir. Bu komut kullanılarak healt durumu anlık izlenebilir. 

`docker container run --rm --name api -d -p 80:80 -e WAIT_TIME=30 pythonweb` \
![HEALTCHECK](/img/dockerfile_p08.png)

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

## IMAGE KATMANLARI
history komutu ile image yi oluşturan katmanlar görüntülenebilir ve her katmanın boyutu hakkında bilgi edinilebilir. \
Kısa gösterim \
`docker image history pythoncustom:v3` \

![docker image history](/img/dockerfile_p10.png)
Uzun Gösterim \
`docker image history --no-trunc pythonweb:latest` \

Yukarıdaki örnekte IMAGE bölümü altında missing yazılan katmanlar indirilmiş katmanlar, eğer 256 bit UUID (universally unique identifier) bir değer içeriyorsa docker host üzerinde oluşturulmuş bir katman olduğunu göstermektedir ve bu ara katmanlara intermediate image denilir.

imageleri görselleştirmek için dockviz imagesinden ve graphviz paketinden yararlanılabilir.

`sudo apt-get install graphviz -y` 

`docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images --dot | dot -Tpng -o images.png`

## TEK KATMANLI IMAGE OLUŞTURMAK [--squash](https://docs.docker.com/engine/reference/commandline/image_build/#options)
[aemon configuration file](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file) \
`echo $'{\n    "experimental": true\n}' | sudo tee /etc/docker/daemon.json` \
`docker image build --squash --tag pyweb .`


## IMAGE bulmak 
`docker search nginx` \
komutu ile hub.docker.com üzerinde image ara yapılabilir. Yada direkt web sitesi üzerinden de bu işlem yapılabilir.
![docker search](/img/docker_search_p01.png)

> ## **NOT: Eğer dockerfile dosyası içerisinde yukarıdan aşağıya doğru çalıştırılan komutlar içerisinde çok fazla değişiklik yapılan dosyalara atıf var ise değişiklik yapılan dosyalar, dockerfile dosyasının sonlarına doğru olması docker image build işleminde yaatılan layer ların daha hızlı build işlemine tabi tutulması ve cache üzerinden işlem yapılmasını sağlayacaktır.**
## ORNEK

| Command        | Description |
| -------------- | ----------- |
| `docker build --tag mycentos:v1 .` <br><br> `docker build -t mycentos:v2 .` <br><br>`docker build --tag mycentos:v1 --file mynewcentos .`<br><br>`docker build -t mycentos:v1 -f mynewcentos .`<br><br>`docker build -t gitcentos https://bit.ly/centosDockerfile`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/)|
| `docker image build --tag esaydam/pyapp .`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/) <br><br> ![docker build](/img/docker_build_p9.png)|
| `docker image history esaydam/pyapp:latest`| image geçmişini göstermek için kullanılır. [docker image history](https://docs.docker.com/engine/reference/commandline/image_history/) <br><br> ![docker image history](/img/docker_build_p10.png)|
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

### **NOT: Multi Stage Build ilk FROM ifadesi ile baraber CMD kullanılmaz. Kullanılsada çalışmayacaktır.**


# ENV ve ARG FARKI

ENV container içerisinde erişilebilecek ve docker container içerisindeki environment variable tanımlaması için kullanılır.

ARG ise image oluşturulurken kullanılan değişkendir.
[argwithout.dockerfile](/examDockerFiles/)\
`docker image build --tag esaydam/arrgusecasewithout --file argwithout.dockerfile .`\
[arg.dockerfile](/examDockerFiles/)\
`docker image build --tag esaydam/arrgusecase --file arg.dockerfile .`

>`docker image build --tag esaydam/arrgusecase:3.10.7 --file arg.dockerfile --build-arg VERSION=3.10.7 .`

> `docker container run --rm -it esaydam/arrgusecase:3.10.7 bash` 
![arg use case](/img/docker_dockerfile_arg_p1.png)

>`docker image build --tag esaydam/arrgusecase:3.8.14 --file arg.dockerfile --build-arg VERSION=3.8.14 .`

> `docker container run --rm -it esaydam/arrgusecase:3.8.14 bash`
![arg use case](/img/docker_dockerfile_arg_p2.png)

ARG bilgisi girilmediği taktirde Dockerfile içerisindeki değer geçerli olacaktır.

> `docker image build --tag esaydam/arrgusecase:latest --file arg.dockerfile .`

> `docker container run -it esaydam/arrgusecase:latest bash`
![arg use case](/img/docker_dockerfile_arg_p3.png)


# DOCKER CONTAINER COMMIT

Bir container yaratılıp üzerinde işlemler yapıldıktan sonra bir image olarak kaydedilmesini sağlar.\
`docker container run -it --name workcontainer ubuntu bash`

> \# `apt-get update && apt-get upgrade -y && apt-get install wget -y`\
> \# `mkdir temp`\
> \# `wget https://www.python.org/ftp/python/3.7.14/Python-3.7.14.tar.xz`\
> \# `exit`

`docker container commit workcontainer workimage:latest`\
![docker container commit](/img/docker_container_commit_p1.png)\
\
`docker container run -it --rm workimage`\
![docker container commit](/img/docker_container_commit_p1.png)

NOT: İstenirse `--change` parametresi kullanılarak container dan image yapılırken yeni image CMD, EXPOSE gibi özellikleride değiştirilebilir. 
`docker container commit --change 'CMD ["java","app"]' registry esaydam/registrycmdchange:v1`\
`docker image inspect esaydam/registrycmdchange:v1`\
![docker container commit](/img/docker_container_commit_p3.png)


# SAVE - LOAD - INTERNET BAĞLANTISI OLMAYAN DOCKER HOST IMAGE TASIMAK
`docker image save workimage --output workimage.tar`\
`docker image prune -a`\
`docker image ls -a`\
`docker image load --input workimage.tar`\
`docker image ls`

# LINUX SHELL KISA BILGI
>## ECHO
console istenilen değeri çıktı olarak yazdırmak için kullanılır.\
`printenv`\
`echo $HOME`

> ## > (büyüktür) İŞARETİ
azılan komuttan sonra > işareti kullanılırsa çıktı olarak ekrana basılacak ifadenin yönelendirilerek bir dosyaya yazılması için kullanılır. Dosya önceden var ise silinir ve tekrar oluşturulur.

> ## >> İŞARETİ
yazılan komuttan sonra > işareti kullanılırsa çıktı olarak ekrana basılacak ifadenin yönelendirilerek bir dosyaya yazılması için kullanılır. Dosya daha önceden var ise dosya sonuna ekleme yapılır.

>## & (ampersand) İŞARETİ
Sonuna geldiği komutun çalışmasının sonuçlandırılmasını beklemez ve direkt shell ekranına tekrar düşer. Komut çalışması devam eder.

>## | (pipe) İŞARETİ
İki komutu birbirine bağlamak için kullanılır ve birinci komutun çıktısının ikinci komuta paremetre olarak verilmesini sağlar.

>## ; (semicolon) İŞARETİ
Tek satırda birden fazla komut çalıştırır. Çalıştırılan komutları birbirine bağlamaz.

>## && (double ampersand) İŞARETİ
Komutlar arasında kullanılır ve iki komutu birbirine birleştirir. 
`komut1 && komut2`
komut1 olumlu bir sonuç döndürdüğünde komut2 de çalışır. Ancak komut1 çalıştığında hata oluşursa komut2 çalışmaz.

>## || (double pipe) İŞARETİ
Komutlar arasında kullanılır ve iki komutu birbirine birleştirir. 
`komut1 || komut2` komut1 olumlu bir sonuç döndürürse komut2 çalıştırılmaz. komut1 hatalı bir sonuç döndürürse komut2 çalışır.
>## GREP komutu
Arama için kullanılır.

>## İstediğimiz boyutta fake bir dosya oluşturmak
`dd if=/dev/zero of=bosdosya bs=10M count=1`

