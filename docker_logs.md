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
| `docker logs --timestamps cnginx` | Logların ne zaman oluştuğunu zaman damgası ile beraber gösterir. nginx log kaydı içerisinde zamanı göstermektedir. Ancak farklı uygulamalar zaman ile ilgili bilgiyi log kaydı atmayabiliyor. Bundan dolayı kullanılmaktadır. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps --since 2022-10-08T06:07:59.674253211Z cnginx` | Belirtilen zamandan sonraki logları gösterir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps --until 2022-10-08T06:07:59.674253211Z cnginx` | Belirtilen zamana kadar olan logları gösterir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker logs --timestamps --since 2022-10-08T06:10:17.694189870Z --until 2022-10-08T06:10:18.451141751Z cnginx` | Belirtilen zaman aralığındaki logları gösterir. [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/) |
| `docker container run --log-driver splunk nginx` | Container yaratılırken log driver seçiminin yapılması sağlanabilir. [docker container run --log-driver](https://docs.docker.com/engine/reference/commandline/container_run/#options) |



