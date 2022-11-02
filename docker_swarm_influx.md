[Install InfluxDB](https://docs.influxdata.com/influxdb/v2.4/install/) \
[InfluxDB](https://github.com/docker-library/docs/blob/master/influxdb/README.md)

[telegraf](https://hub.docker.com/_/telegraf)

[Grafana Installation](https://grafana.com/docs/loki/latest/installation/)



# InfluxDB
## NETWORK KURULUMU
docker containerlar kendi aralarında da network haberleşmesini encryped olarak yapmak istenirse network oluşturulmasını aşağıdaki komut ile yapılabilir.

`docker network create --driver overlay --opt encrypted --attachable netmon`

Network haberleşmesi encrypted istenimiyorsa aşağıdaki gibi network yaratılabilir.

`docker network create --driver overlay --attachable netmon` 

## InfluxDB KURULUMU

    docker run \
    --rm influxdb:2.4.0 \
    influxd print-config > influxdb.config.yml


<br>

`mkdir influxdb2`

    docker run -d -p 8086:8086 \
    --name influxdb \
    --user $(id -u) \
    --volume $PWD/influxdb.config.yml:/etc/influxdb2/config.yml \
    --volume $PWD/influxdb2:/var/lib/influxdb2 \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --net=netmon \
    -e DOCKER_INFLUXDB_INIT_MODE=setup \
    -e DOCKER_INFLUXDB_INIT_USERNAME=admin \
    -e DOCKER_INFLUXDB_INIT_PASSWORD=password \
    -e DOCKER_INFLUXDB_INIT_ORG=myorg \
    -e DOCKER_INFLUXDB_INIT_BUCKET=telegraf \
    influxdb:2.4.0 --reporting-disabled
Aşağıdaki komutu çalıştırmaya gerek kalmamaktadır. Docker run komutu içerisine environment olarak eklediğimiz değerler aşağıdaki komutun yaptığı işlemi yapmaktadır. \
`docker exec -it influxdb influx setup`

Şimdi influxdb containerının çalışıp çalışmadığını kontrol edelim. \
`docker ps -a | grep influxdb` \
Eğer influxdb container ı içerisinde bir komut çalıştıracak ise aşağıdaki ifade kullanılabilir. \
`docker exec -it influxdb /bin/bash`

## TELEGRAF KURULUMU
Telegraf configurasyon dosyasını docker kullanarak dışarıya aktardık.

`docker run --rm telegraf telegraf config > telegraf.conf` 

Telegraf configurasyon dosyasını docker kullanarak dışarıya aktardık. Ancak bu sefer gelen verilerin neler olması gerektiğinide belirtmiş olduk.

`docker run --rm telegraf telegraf --input-filter cpu:mem:net:swap --output-filter influxdb:kafka config > cpu_mem_net_swap.telegraf.conf`

Yukarıdaki iki farklı telegraf conf dosyasından birisi seçilerek uygulamaya devam edilir.

Configurasyon dosyası içerisinde gerekli olan TOKEN ayarlaması için öncelikle InfluxDB arayüzü açılarak işlem yapılır.

![InfluxDB](/img/docker_influxdb_telegraf_p01.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p02.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p03.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p04.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p05.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p06.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p07.png) \
![InfluxDB](/img/docker_influxdb_telegraf_p08.png) 

burada indirilen dosya telegraf docker containerı için kullanılacak conf dosyası olacaktır. 

![InfluxDB](/img/docker_influxdb_telegraf_p09.png) 
<br>
Eğer telegraf influxdb container kullanım oranlarını izleyecek şekilde yapılandırılması isteniyor ise aşağıdaki komut kullanılır.

    docker run -d --name=telegraf \
    --net=container:influxdb \
    -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
    telegraf

<hr>

Eğer telegraf ayrı bir container a yüklenecek ise aşağıdaki komutlardan uygun olanı kullanılır.

    docker run -d --name=telegraf \
      --net=netmon \
      -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
      telegraf
<br>

    docker run -d --name=telegraf \
      --net=netmon \
      -v $PWD/cpu_mem_net_swap.telegraf.conf:/etc/telegraf/telegraf.conf:ro \
      telegraf

<hr>
Telegraf sunucusunun düzgün çalışığ çalışmadığını log kontrolü ile anlayabiliriz.

`docker logs -f telegraf` 

![InfluxDB](/img/docker_influxdb_telegraf_p10.png) 

3 ile gösterilen bölgede değerler geliyorsa bağlantıyı telegraf influxdb üzerine veri aktarıyor demektir.


# GRAFANA KURULUM
[grafana Installation](https://grafana.com/docs/loki/latest/installation/)

    wget https://raw.githubusercontent.com/grafana/loki/v2.6.1/production/docker-compose.yaml -O docker-compose.yml

yml dosyası üzerinde değişiklik yapılması gerekli olabilir. Örneğin network ayarlarında değişikliğe gitti iseniz lütfen docker-compose.yml dosyası içerisinde de değiştiriniz.
<pre>
version: "3"

networks:
  netmon:
    external: true

services:
  loki:
    image: grafana/loki:2.6.0
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - netmon

  promtail:
    image: grafana/promtail:2.6.0
    volumes:
      - /var/log:/var/log
    command: -config.file=/etc/promtail/config.yml
    networks:
      - netmon

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    networks:
      - netmon

</pre>
`docker compose up -d`

![grafana](/img/docker_influxdb_grafana_p01.png)

[Get started with Flux and InfluxDB](https://docs.influxdata.com/influxdb/v2.4/query-data/get-started/)
