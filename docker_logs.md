# DOCKER LOGS
Varsayılan log driver json-file dır. Log driver leri görüntülemek için `docker info` komutundan yararlanılabilir.\
Ayrıca container **silinene** kadar logları incelenebilir.\
![docker logs](/img/docker_logs_p2.png)
![linux stdin stdout stderr](/img/linux_stdin_stdout_stderr.png)


`docker container run -dit --name cnginx -p 80:80 nginx`\
`docker logs cnginx`\
nginx logları normalde /var/log/nginx altında access.log ve error.log dosyalarında tutulmaktadır. Ancak docker STDIN,**STDOUT,STDERR** izleyerek log takibi yaptığından bu dosyalar **symbolic links** olarak container içerisinde yönlendirilmiştir. (`ln -s [Specific file/directory] [symlink name]`) Bu bilgiyi göze alarak kendi yaptığınız uygulamalarda da docker tarafından logların takibinin yapılabilmesi için düzenleme yapılmalıdır.\
`docker exec -it cnginx sh`\
`cd /var/log/nginx/`\
`ls -l`|\
![docker logs](/img/docker_logs_p1.png)

| Command        | Description |
| -------------- | ----------- |
| `docker container logs 36` | Belirtilen containerın loglarını gösterir. shell ekranındaki kullanılan komutların listesini gösterir.[docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --details cnginx` | Daha detaylı log gösterimi için kullanılır.[docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --follow cnginx` | Canlı log takibi yapar. Çıkmak için CTRL+C tuş kombinasyonu kullanılır.[docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --tail 5 cnginx` | Container ismi ile belirtilen docker nesnesinin son 5 logunu göstermek için kullanılır. Satır sayısının kaç olacağı isteğe bağlıdır. Kullanılması zorunludur. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --tail 5 --follow cnginx` | Container ismi ile belirtilen docker nesnesinin --tail parametresi ile son 5 logunu göstermek için kullanılır. Satır sayısının kaç olacağı isteğe bağlıdır. Kullanılması zorunludur. --follow ile de anlık izleme yapılabilir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps cnginx` | Logların ne zaman oluştuğunu zaman damgası ile beraber gösterir. nginx log kaydı içerisinde zamanı göstermektedir. Ancak farklı uygulamalar zaman ile ilgili bilgiyi log kaydı atmayabiliyor. Bundan dolayı kullanılmaktadır. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps --since 2022-10-08T06:07:59.674253211Z cnginx` | Belirtilen zamandan sonraki logları gösterir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps --until 2022-10-08T06:07:59.674253211Z cnginx` | Belirtilen zamana kadar olan logları gösterir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps --since 2022-10-08T06:10:17.694189870Z --until 2022-10-08T06:10:18.451141751Z cnginx` | Belirtilen zaman aralığındaki logları gösterir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker container run --log-driver splunk nginx` | Container yaratılırken log driver seçiminin yapılması sağlanabilir. [docker container run --log-driver](https://docs.docker.com/engine/reference/commandline/container_run/#options) |
| `docker container run -dit --name cnginx -p 80:80 --log-driver json-file nginx` | Container yaratılırken log driver seçiminin yapılması sağlanabilir. [docker container run --log-driver](https://docs.docker.com/engine/reference/commandline/container_run/#options) |

## DOCKER LOG DRIVERS
Docker üzerinde log kayıtlarını tutabilsek de bu kayıtların bir veritabanına aktarılması gerekli. Bunun için çeşitli log sürücüleri bulunmaktadır.
- [awslogs](https://docs.docker.com/config/containers/logging/awslogs/)
- [etwlogs](https://docs.docker.com/config/containers/logging/etwlogs/)
- [fluentd](https://docs.docker.com/config/containers/logging/fluentd/)
- [gcplogs](https://docs.docker.com/config/containers/logging/gcplogs/)
- [gelf](https://docs.docker.com/config/containers/logging/gelf/)
- [journald](https://docs.docker.com/config/containers/logging/journald/)
- [json-file](https://docs.docker.com/config/containers/logging/json-file/)
- [local](https://docs.docker.com/config/containers/logging/local/)
- [logentries](https://docs.docker.com/config/containers/logging/logentries/)
- none
- [splunk](https://docs.docker.com/config/containers/logging/splunk/)
- [syslog](https://docs.docker.com/config/containers/logging/syslog/)

Varsayılan sürücü local olarak kullanılır. Docker Host üzerinde log dosyaları `/var/lib/docker/containers/` path i üzerinde bulunur. `docker logs cnginx` ile almış olduğumuz çıktı buradaki log dosyasının içeriğini bize göstermektedir. \
![docker logs](/img/docker_logs_p3.png) \
![docker logs](/img/docker_logs_p4.png) \

Ayrıca [Daemon configuration file](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file) Docker Daemon ayarlarını kontrol edebilirsiniz.

Eğer none olarak log driver seçilir ise log tutmamak için kullanılan, kendine gelen logları görmezden gelmeyi sağlayan bir deyimdir. 


