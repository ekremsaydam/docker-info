# DOCKER COMPOSE
Büyük yapılar için web sunucuları, veritabanı utgulamaları, caching mekanizmaları, mikro servisler, back end servisleri gibi birbirine bağlı olarak çalışan birçok uygulamayı ayrı ayrı oluşturmak yerine tek seferde oluşturarak zamandan tasarruf etmek için docker compose kullanılır. Dockerfile tek bir container yaratmak ve çalıştırmak için kullanılırken docker-compose birden fazla çoklu container oluşturmamıza olanak sağlar.

Birden fazla container ı yml dosyası olarak tanımlamak için kullanılıyor. Docker compose product ortamlar için uygun değildir. Daha çok development tarafı için kullanılmaktadır.\
[YAML YML](https://yaml.org/)\
[Compose file specification](https://docs.docker.com/compose/compose-file/)

docker-compose.yml dosyasının ana bölümleri (top level):
- version
- services
- volumes
- networks
- secrets
- name
- configs

## docker compose on ubuntu
Kısa yükleme
`sudo apt-get install docker-compose`

<hr>


[INSTALL](https://docs.docker.com/compose/install/linux/)

`sudo apt-get update`\
`sudo apt-get install docker-compose-plugin`\
`docker compose version`


Komut satırında docker-compose komutu ile çalışmak için ve intellisense

<pre>
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
</pre>

<pre>
mkdir -p $DOCKER_CONFIG/cli-plugins
</pre>

<pre>
curl -SL https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
</pre>

<pre>
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
</pre>

> `docker compose version`

> `sudo cp $DOCKER_CONFIG/cli-plugins/docker-compose /usr/local/bin/docker-compose`

>`sudo chmod +x /usr/local/bin/docker-compose`\
veya\
> `sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`

intellicence için
> `sudo apt-get install docker-compose`
# docker-compose.yaml - docker-compose.yml dosyası Hazırlama

[Compose file specification](https://docs.docker.com/compose/compose-file/)\
[The Compose Specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md) *yararlanılan Ana kaynak*

[Compose specification](https://docs.docker.com/compose/compose-file/)\
[compose-spec.io](https://compose-spec.io/)

## [version](https://github.com/compose-spec/compose-spec/blob/master/spec.md#version-top-level-element)
docker compose versiyonları arasındaki barındırdıkları fonksiyonel özellikleri bakımından farklılıklar bulunmaktadır. Ancak bu özellik **kaldırılmıştır**. [Compose file](https://github.com/compose-spec/compose-spec/blob/master/spec.md#compose-file)\
[Compose file versions](https://docs.docker.com/compose/compose-file/compose-versioning/)

## [services](https://github.com/compose-spec/compose-spec/blob/master/spec.md#services-top-level-element)
container ların iskeletini oluşturan soyut bir kavramdır. image ve bir dizi çalışma zamanı argümanları ile tanımlanır. 

Bir services tanımı altında en az bir tane kök öğe bulunmak zorundadır. 

dockerfile ile oluşturulacak içerik direkt her services bölümü altında oluşturulabilir. yinede dockerfile kullanılacak ise bunada destek sağlamaktadır. [The Compose Specification - Build support](https://github.com/compose-spec/compose-spec/blob/master/build.md)

## [image](https://github.com/compose-spec/compose-spec/blob/master/spec.md#image)
Çalıştırılacak olan container ın kullanacağı imajı belirtmek için kullanılır.

## [depends_on](https://github.com/compose-spec/compose-spec/blob/master/spec.md#depends_on)
Aldığı değerde yazılı olan container çalışmadan bağlı olduğu container çalışmayacaktır. Kısaca hizmetler arasındaki başlatma ve kapatma bağımlılığını ifade eder.

`docker compose stop` komutu ile servisler durdurulduğunda sıralama `depends_on` paremetresine göre işler.
<pre>
services:
  web:
    build: .
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
  redis:
    image: redis
  db:
    image: postgres
</pre>
yukarıdaki örneğe göre önce redis ve db service si kapatılıp ardından web servicesi kapatılır.

## [ports](https://github.com/compose-spec/compose-spec/blob/master/spec.md#ports)
Erişime açılacak portlar belirtilir.
aşağıda kısa örnekler verilmiştir.
<pre>
ports:
  - "3000"
  - "3000-3005"
  - "8000:8000"
  - "9090-9091:8080-8081"
  - "49100:22"
  - "127.0.0.1:8001:8001"
  - "127.0.0.1:5000-5010:5000-5010"
  - "6060:6060/udp"
</pre>

uzun hali:
<pre>
ports:
  - target: 80
    host_ip: 127.0.0.1
    published: 8080
    protocol: tcp
    mode: host

  - target: 80
    host_ip: 127.0.0.1
    published: 8000-9000
    protocol: tcp
    mode: host
</pre>
**target**: container için geçerli port\
**published**: herkese açık bağlantı noktası. Bir aralık olarak belirtilebilir.\
**host_ip**: Host ip adresi belirtilebilir. Varsayılan olarak üm ağ arayüzleri\
tanımlanır bunun için 0.0.0.0 kullanılabilir.\
**protocol**: udp veya tcp olarak bağlantı noktası protokolü. Belirtilmemiş ise her iki protokol anlamına gelir.

## [build](https://github.com/compose-spec/compose-spec/blob/master/build.md)
container lar `build` ile belirtilen dizin üzerinden veya `context` ve  `dockerfile` alt parametreleri ile beraber dockerfile üzerinden de container oluşturulabilir. Ayrıca Dockerfile ile hazırlanmış bir bir image içinde `docker compose build` ve `docker compose up` uygulanmalıdır.
<pre>
services:
  frontend:
    image: awesome/webapp
    build: ./webapp

  backend:
    image: awesome/database
    build:
      context: backend
      dockerfile: ../backend.Dockerfile

  custom:
    build: ~/custom
</pre>

## [command](https://github.com/compose-spec/compose-spec/blob/master/spec.md#command)
container ilk çalıştığında işlenecek komutları yazmak için kullanılır.\
dockerfile içerisinde CMD ve comut satırındaki exec üzerine yazar.\
dockerfile da CMD de olduğu gibi bir kullanım şekli vardır.\
`command: [ "bundle", "exec", "thin", "-p", "3000" ]`

## [dns](https://github.com/compose-spec/compose-spec/blob/master/spec.md#dns)
services lerin kullanacağı dns sunucusu yada sunucularını belirtmek için kullanılır. Birtane olabileceği gibi bir liste de belirtilebilir.
<pre>
dns: 8.8.8.8
</pre>
<pre>
dns:
  - 8.8.8.8
  - 9.9.9.9
</pre>

## [entrypoint](https://github.com/compose-spec/compose-spec/blob/master/spec.md#entrypoint)

önceden kullanılmış bir entrypoint varsa docker compose dosyasında kullanılan parametreler bu önceden tanımlı değerleri ezerek kullanır. dockerfile içerisinde yazılmış CMD var ise entrypoint bu değeri bu argümanıda ezecektir.
<pre>
entrypoint:
  - php
  - -d
  - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
  - -d
  - memory_limit=-1
  - vendor/bin/phpunit
</pre>

## [environment](https://github.com/compose-spec/compose-spec/blob/master/spec.md#environment)

container lar içerisinde kullanılacak olan çevresel parametre değişkenleri tanımlar.
<pre>
environment:
  RACK_ENV: development
  SHOW: "true"
  USER_INPUT:
</pre>

<pre>
environment:
  - RACK_ENV=development
  - SHOW=true
  - USER_INPUT
</pre>

## [healthcheck](https://github.com/compose-spec/compose-spec/blob/master/spec.md#healthcheck)
Servislerin erişim durumunu gösteren healthcheck yolunu ve süre opsiyonlarını belirtir. dockerfile içerisinde tanımlı healthcheck var ise geçersiz kılar.
<pre>
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 1m30s
  timeout: 10s
  retries: 3
  start_period: 40s
</pre>
<pre>
test: ["CMD", "curl", "-f", "http://localhost"]
</pre>
<pre>
test: ["CMD-SHELL", "curl -f http://localhost || exit 1"]
</pre>
<pre>
test: curl -f https://localhost || exit 1
</pre>

## [labels](https://github.com/compose-spec/compose-spec/blob/master/spec.md#labels)
container ların metadata bilgisidir. erişim ve gruplama konularında kolaylık sağlar.

Etiketlerinizin diğer yazılımlar tarafından kullanılanlarla çakışmasını önlemek için ters DNS gösterimi kullanmanız önerilir.

<pre>
labels:
  com.example.description: "Accounting webapp"
  com.example.department: "Finance"
  com.example.label-with-empty-value: ""
</pre>
<pre>
labels:
  - "com.example.description=Accounting webapp"
  - "com.example.department=Finance"
  - "com.example.label-with-empty-value"
</pre>

## [logging](https://github.com/compose-spec/compose-spec/blob/master/spec.md#logging)

Bağlı olduğu service nin log yönlendirme ayarlarını tanımlar. varsayılan olarak bu ayar json-file olarak ayarlıdır. 

Bir syslog sunucusuna aşağıdaki gibi ayarlanabilir.

<pre>
logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.0.42:123"
</pre>
## [volumes](https://github.com/compose-spec/compose-spec/blob/master/spec.md#volumes)
dizin yollarını belirtmek için kullanılır.
<pre>
services:
  backend:
    image: awesome/backend
    volumes:
      - type: volume
        source: db-data
        target: /data
        volume:
          nocopy: true
      - type: bind
        source: /var/run/postgres/postgres.sock
        target: /var/run/postgres/postgres.sock

volumes:
  db-data:
</pre>

# docker compose komutu ile çalışmak

| Command        | Description |
| -------------- | ----------- |
| `docker compose up` <br><br>`docker compose --file nginxmariadb.docker-compose.yml up` <br><br>`docker compose --file nginxmariadb.docker-compose.yml up -d`|Belirtilen docker compose dosyasındaki sadece services container olarak run eder.(ayağa kaldırır). docker compose dosyası belirtilmez ise komut çalıştırılan klasör içerisinde `docker-compose.yml` dosyasını arar. `-d --detach` containerları arka planda çalıştırır. [docker compose up](https://docs.docker.com/compose/reference/)|
<pre>
services:
  nginx:
    image: nginx
  redis:
    depends_on:
      - nginx
    image: redis
    ports:
      - "8080:80"
</pre>
| Command        | Description |
| -------------- | ----------- |
| `docker compose config`<br><br>`docker compose -f nginxmariadb.docker-compose.yml config`|Olası sözdizimi hatalarını kontrol eder. Hangi sırada işlem yapacağını gösterir. Yazmış olduğumuz yml dosyasını tersten işletiyomuş gibi gösterir. <br> ![docker compose up](/img/docker_compose_p1.png)|
| `docker compose --services` <br><br>`docker compose -f nginxmariadb.docker-compose.yml config --services` |Belirtilen docker compose dosyasındaki sadece services isimlerini görüntülemek için kullanılır.|
| `docker compose create` <br><br>`docker compose --file nginxmariadb.docker-compose.yml create` |containerları create eder. Ancak çalıştırmaz.|
| `docker compose down` <br><br>`docker compose --file nginxmariadb.docker-compose.yml down` |docker compose ile başlatılan services, `container` ve  `network` arayüzlerini **siler**. **Ancak `volume` ve `image` silmez**. [docker compose down](https://docs.docker.com/engine/reference/commandline/compose_down/)|
| `docker compose down --rmi all` <br><br>`docker compose --file nginxmariadb.docker-compose.yml down --rmi all` |docker compose ile başlatılan services, `container`, `network` ve `image` arayüzlerini **siler**. Ancak `volume` **silmez**. [docker compose down](https://docs.docker.com/engine/reference/commandline/compose_down/)|
| `docker compose down --rmi all --volumes` <br><br>`docker compose --file nginxmariadb.docker-compose.yml down --rmi all --volumes` |docker compose ile başlatılan services, `container`, `network`, `image` ve `volume` arayüzlerini **siler**. [docker compose down](https://docs.docker.com/engine/reference/commandline/compose_down/)|
| `docker compose events` <br><br>`docker compose --file nginxmariadb.docker-compose.yml events` |docker compose uygulamalarının anlık monitör edilmesini sağlar.. [docker compose down](https://docs.docker.com/engine/reference/commandline/compose_down/)|
| `docker compose exec redis tail /var/log/alternatives.log` <br><br>`docker compose -f nginxmariadb.docker-compose.yml exec redis tail /var/log/alternatives.log` <br><br>`docker exec cf5b01b7133b tail /var/log/alternatives.log` |docker compose ile çalıştırılan belirtilen konteynere bağlanarak üzerinde komut çalıştırmak için kullanılır. docker compose dosyası üzerinden çalıştırılmış service üzerinde girilen komut yürütülür. bir compose dosyası var ise servis ismi kullanılır. docker container exec ile ise container ismi yada ID si üzerinden komut yürütme işlemi yapılabilir. [docker compose exec](https://docs.docker.com/engine/reference/commandline/compose_exec/)|
| `docker compose images` <br><br>`docker compose -f nginxmariadb.docker-compose.yml images` |docker-compose.yml dosyası üzerinden oluşturulmuş image lerin listesini gösterir. [docker compose exec](https://docs.docker.com/engine/reference/commandline/compose_images/)|
| `docker compose kill` <br><br>`docker compose -f nginxmariadb.docker-compose.yml kill` |çalışan containerları durdurur. down parametresinden farkı silmemesidir. Sadece çalışan bilgisayarın fişi çekilmiş gibi işlem yapar. Olası veri kayıpları olabilir. [docker compose kill](https://docs.docker.com/engine/reference/commandline/compose_kill/)|
| `docker compose logs` <br><br>`docker compose -f nginxmariadb.docker-compose.yml logs` |docker compose ile oluşturulan container ların loglarını görüntüler. [docker compose logs](https://docs.docker.com/engine/reference/commandline/compose_logs/)|
| `docker compose logs -f` <br><br>`docker compose -f nginxmariadb.docker-compose.yml logs -f` | docker compose ile oluşturulan container ların loglarını anlık olarak takip edilmesini sağlar.[docker compose logs](https://docs.docker.com/engine/reference/commandline/compose_logs/)|
| `docker compose ls` | docker compose ile oluşturulan projeleri listeler. [docker compose ls](https://docs.docker.com/engine/reference/commandline/compose_ls/) ![docker compose ls](/img/docker_compose_p2.png)|
| `docker compose pause` <br><br> `docker compose -f nginxmariadb.docker-compose.yml pause`| docker compose dosyası ile oluşturulan hizmetleri duraklatır. services i yeniden devam ettirmek için `unpause` komutu kullanılır.[docker compose pause](https://docs.docker.com/engine/reference/commandline/compose_pause/)|
| `docker compose unpause` <br><br> `docker compose -f nginxmariadb.docker-compose.yml unpause`| docker compose dosyası ile oluşturulan hizmetleri yeniden devam ettirmek için `unpause` komutu kullanılır.[docker compose unpause](https://docs.docker.com/engine/reference/commandline/compose_unpause/)|
| `docker compose ps` <br><br> `docker compose -f nginxmariadb.docker-compose.yml ps`| docker compose dosyası ile oluşturulan hizmetleri listeler. [docker compose ps](https://docs.docker.com/engine/reference/commandline/compose_ps/)|
| `docker compose pull` <br><br> `docker compose -f nginxmariadb.docker-compose.yml pull`| docker compose dosyası içerisindeki services ait image dosyalarını indirir. [docker compose pull](https://docs.docker.com/engine/reference/commandline/compose_pull/)|
| `docker compose restart` <br><br> `docker compose -f nginxmariadb.docker-compose.yml restart`| docker compose dosyası içerisindeki services ait çalışan container ları yeniden başlatır. [docker compose restart](https://docs.docker.com/engine/reference/commandline/compose_restart/)|
| `docker compose rm` <br><br> `docker compose -f nginxmariadb.docker-compose.yml rm`| docker compose dosyası içerisindeki services ait durdurulmuş containerı kaynakları ile beraber siler. `docker compose down` kullanımı container kaynaklarının tamamının kaldırılması adına kullanımı daha iyidir.[docker compose rm](https://docs.docker.com/engine/reference/commandline/compose_rm/)|
| `docker compose start` <br><br> `docker compose -f nginxmariadb.docker-compose.yml start`| durdurulan docker compose dosyası ile oluşturulan container ları çalıştırmak için kullanılır.[docker compose start](https://docs.docker.com/engine/reference/commandline/compose_start/)|
| `docker compose stop` <br><br> `docker compose -f nginxmariadb.docker-compose.yml stop`| durdurulan docker compose dosyası ile oluşturulan container ları durdurmak için kullanılır. container silme işlemi yapmaz. stop ile durdurulan containerlar start ile çalıştırılabilir.[docker compose stop](https://docs.docker.com/engine/reference/commandline/compose_stop/)|
| `docker compose top` <br><br> `docker compose -f nginxmariadb.docker-compose.yml top`<br><br>`docker compose -f nginxmariadb.docker-compose.yml top nginx`| deploy edilen containerların çalıştırdıkları uygulamaların listesi görüntülenir. services ismi ile beraber kullanıldığında sadece o service ait çalıştırılan uygulamalar listelenir. [docker compose top](https://docs.docker.com/engine/reference/commandline/compose_top/)<br>![docker compose top](/img/docker_compose_p3.png)|
| `docker compose version`| docker compose versiyonunu görüntüler. [docker compose top](https://docs.docker.com/engine/reference/commandline/compose_version/)|

## DOCKER COMPOSE and NETWORKS
[Networks top-level element](https://docs.docker.com/compose/compose-file/#networks-top-level-element)
Varsayılan olarak herbir docker-compose.yml dosyası için ortak bir ağ oluşturur. compose ile oluşturulan containerlar ayrı service olsalar dahi birbirleri ile varsayılan olarak haberleşebilirler. Otomatik olarak atanan bu ağ arayüzü değiştiririlebilir.<br>
[network.docker-compose.yml](/docker-compose/network.docker-compose.yml)
<pre>
services:
  frontend:
    image: nginx
    networks:
      - front-tier
      - back-tier

networks:
  front-tier:
  back-tier:
</pre>
`docker compose -f network.docker-compose.yml up -d`

Yukarıdaki örnekte frontend adında bir service tanımlanmış. network parametresi ile ii tane ağ arayüzü tanımlaması yapılmış. Dosyanın son bölümünde ayrı bir network segmenti ile yeni ağ arayüzü belirtilmiştir. 

Dikkat edilmesi gereken services bölümünden bağımsız olarak networks arayüzü tanımlanmalıdır. 

`docker network` komutunda olduğu gibi yeni oluşturulan network `bridge` modunda oluşturulmaktadır. `docker network inspect` ile network configurasyonu incelenebilir.

![docker compose top](/img/docker_compose_p4.png)

docker compose file içerisinde ipam direktifi ile network arayüzüne subnet,ip aralığı ve gateway gibi daha geniş ayarlamaları yapabiliyoruz.
[ipam](https://docs.docker.com/compose/compose-file/#ipam)\
[networkextends.docker-compose](/docker-compose/networkextends.docker-compose.yml)
<pre>
networks:
  front-tier:
    ipam:
      driver: default
      config:
        - subnet: 172.28.0.0/16
          ip_range: 172.28.5.0/24
          gateway: 172.28.5.254
          aux_addresses:
            host1: 172.28.1.5
            host2: 172.28.1.6
            host3: 172.28.1.7
      options:
        foo: bar
        baz: "0"
</pre>

nginx üzerinde ifconfig ve ping çalıştırabilmek için
`apt-get update`\
`apt install net-tools` (ifconfig çalıştırabilmek için)<br>
`apt-get install iputils-ping` (ping komutunu çalıtırabilmek için)


## ÖLÇEKLENDİRME (--scale)
docker-compose.yml dosyası içerisindeki container replikasyonunu scale parametresi ile gerçekleştirir.[docker compose up --scale](https://docs.docker.com/engine/reference/commandline/compose_up/#options)

Replikasyon sayısı artırılabilindiği gibi aynı zamanda düşürülebilir.

![docker compose top](/img/docker_compose_p5.png)


## NOT: docker-compose.yml dosyası içerisinde build: kullanılacak ise ve build Dockerfile üzerinden alınıyor ise yapılan değişikliklerinde etkili olabilmesi için `docker-compose build` ve sonrasında `docker-compose up` kullanılmalıdır. 

[docker-compose.yml](/docker-compose/webmysqldockerfile/docker-compose.yml)\
[Dockerfile](/docker-compose/webmysqldockerfile/Dockerfile)

## Yukarıdaki dosyalardan yararlanılarak web klasörü içerisinde değişiklik yapıldığında image ninde bu değişiklikleri yapabilmesi için mutlaka `docker-compose build` yapılmalıdır. build yapılmadan `docker-compose up` denildiğinde sunucu çalışır ancak eski dosyalar sunucu üzerinde görüntülenir. Bunun nedeni `docker-compose down` ile image nin silinmemesidir.