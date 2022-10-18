# A. TLS GÜVENLİĞİ 
1. Sertifika çiftinin oluşturulması \
`openssl genrsa -aes256 -out docker-ca-key.pem 4096` <br><br>
`openssl req -new -x509 -days 365 -key docker-ca-key.pem -sha256 -out docker-ca.pem`
<br><br>

2. CSR'in Oluşturulması \
`openssl genrsa -out server-key.pem 4096` <br><br>
`openssl req -subj "/CN=hub" -sha256 -new -key server-key.pem -out docker-server.csr` <br><br>
CN olarak FQDN ismi kullanılmalıdır.
<br><br>

3. TLS Detaylarının Belirlenmesi \
`apt-get install net-tools` \
`ifconfig` \
`echo subjectAltName = DNS:hub,IP:127.0.0.1,IP:192.168.200.135 > dockerext.cnf` \
`echo extendedKeyUsage = serverAuth >> dockerext.cnf` \
`cat dockerext.cnf` \
![](/img/docker_security_p1.png)<br><br>

4. İmzalı Sertifikanın Oluşturulması \
`openssl x509 -req -days 365 -sha256 -in docker-server.csr -CA docker-ca.pem -CAkey docker-ca-key.pem -CAcreateserial -out server-cert.pem -extfile dockerext.cnf`<br<br>

5. Dosya izinlerinin Ayarlanması \
Anahtarların güvenliklerini varsayılan olarak 644 olarak belirlenmiştir. Bu izinleri 400 olarak değiştirelim ve ihtiyacımız olmayan .csr ve .cnf dosyalarını silelim.\
`chmod 400 *.pem` \
`chmod 444 *.csr` \

6. Docker Daemon yeni ayarlarla başlatılması
`systemctl stop docker` \
`dockerd --tlsverify --tlscacert=docker-ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem -H=0.0.0.0:2376` \
`systemctl start docker`
<br><br>

# B. Standart Yetkili Kullanıcı İle çalışmak 
Docker aksi belirtilmediği sürece root kullanıcısı ile çalışır.\
![](/img/docker_security_p2.png)

`docker image build --tag alpinex .` \
`docker container run --user newuser alpinex whoami` \
[Dockerfile](/examDockerFiles/docker-security/Dockerfile)
![](/img/docker_security_p3.png)

# C. DOSYA SİSTEMLERİNİN LİMİTLENMESİ
`docker container run --rm --read-only alpine touch x` \
![](/img/docker_security_p4.png) \

`docker container run --rm --volume /volume1:/volume1:ro alpine touch /volume1/x` \
![](/img/docker_security_p5.png)

# D. APPARMOR Profile
`sudo apt-get update` \
`sudo apt-get install apparmor-profiles` \
[apparmor profile template](https://github.com/moby/moby/blob/master/profiles/apparmor/template.go) \
`sudo apparmor_status` \
![](/img/docker_security_p6.png) \
[docker-default](/examDockerFiles/docker-security/docker-default) 

`sudo apparmor_parser -r -W /etc/apparmor.d/docker-default` 

`docker container run --security-opt "apparmor=docker-apparmor" --detach --tty --name apparmor-test ubuntu` \
`docker container exec -ti apparmor-test bash` \
`cd home/`\
`ls > test.txt` \
![apparmor docker-default](/img/docker_security_p7.png) \
`apt-get update` \
![](/img/docker_security_p8.png)

Eğer apparmor docker-default profili kullanılmazsa aşağıdaki çıktı elde edilir. \
`docker container run -d -t --name apparmor-test2 ubuntu` \
`docker container exec -ti apparmor-test2 bash` \
`apt-get update` \
![not use apparmor default profile](/img/docker_security_p9.png)

apparmor audit loglarını görüntüleyebilirsiniz.
`sudo dmesg` \
![](/img/docker_security_p10.png)

`sudo apparmor_status` (veya kısa yazım şekli kullanılabilir.)\
`sudo aa-status` \
![](/img/docker_security_p11.png)


# E. Auditing Perspektifi
Açık portların kullanım durumunu öğrenmek önemlidir.

`docker ps --quiet | xargs docker container inspect --format '{{ .Id }}: Ports={{ .NetworkSettings.Ports }}'` \
Container oluşturulurken `-P` veya `--publish-all` parametresi kullanmak yerine sadece dışa açılması gereken portların bind edilmesi tercih edilmelidir.

# F. KAYNAK kullanımı
`docker ps --quiet | xargs docker container inspect --format '{{ .Id }} {{ .Name }} : Memory={{ .HostConfig.Memory }} : CpuShares={{ .HostConfig.CpuShares}} : Ports={{.NetworkSettings.Ports}}'` \
Eğer momory 0 görüntüleniyorsa bir kaynak kısıtlamasının bulunmadığını göstermektedir. Varsayılan olarak container lar limitsiz olarak başlatılır.

# G. PID MOD
`docker container run -it --rm --pid host nginx` \
Örnek olarak pid mode host makinesi ile ortak namespace kullanımı olarak ayarlanmıştır. Deneysel anlamda bu tarz kullanım sözkonusu olabilir. Ancak öerilmemektedir.

NOT: `--pid container:<name:id>` olarak kullanılabilir.

`docker ps --quiet | xargs docker container inspect --format '{{ .Id }} PidMode={{ .HostConfig.PidMode }}'` \
![](/img/docker_security_p12.png)




# E. SWARM SECRET KULLANIMI

Secret kullanıcı bilgileri ve parola gibi çeşitli hassas bilgileri güvenli bir şekilde docker ortamında saklar. Ayrıntılı bilgi için [docker_secret.md](./docker_secret.md) incelenebilir.

# F. DOCKER Bench for Security
CIS standartlarını içeren docker güvenlik ve audit yapılandırmalarını otomatik olarak kontrol ederek kullanıcıya rapor sunan, açık kaynaklı bir bash scriptidir.

`docker image pull docker/docker-bench-security`

    docker run -it --net host --pid host --userns host --cap-add audit_control \
        -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
        -v /var/lib:/var/lib \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /usr/lib/systemd:/usr/lib/systemd \
        -v /etc:/etc --label docker_bench_security \
        docker/docker-bench-security
![Docker Bench for Security](/img/docker_security_p13.png) \
![DOCKER Bench for Security](/img/docker_security_p14.png) \