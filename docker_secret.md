# [DOCKER SECRET](https://docs.docker.com/engine/reference/commandline/secret/)
[Manage sensitive data with Docker secrets](https://docs.docker.com/engine/swarm/secrets/)
- Docker secret swarm modu aktifken kullanılabilir bir özelliktir. 
- Dockerfile yada docker-compose.yml dosyası içerisinde yazmış olduğumuz şifreleri clear text(plaint text) olarak bırakmak yerine şifreleyerek bertilen container lar tarafından kullanılması sağlanabilir. Böylelikle güvenlik sağlanmış olur.
- image içerisinede şifre gömmülmesi ve o şekilde kullanılması da şifreler için güvenli değildir.
- encrypted olarak raf deposuna kaldırılan anahtar değerler swarm ile kullanılabilir. Herhangi bir swarm node üzerinde kullanılmak istense encrypted olarak o node üzerine transfer edilir ve istenilen node üzerinde bu anahtarlar container tarafında kullanılabilir.

| Command        | Description |
| -------------- | ----------- |
|`docker swarm init`| Docker swarm aktif hal getirilmesi için kullanılır. |
|`docker secret create kullanici_adi kullaniciadi.txt`| [kullanıcı.txt](/examDockerFiles/dockersecret/kullaniciadi.txt) içerisindeki verinin kullanici_adi secret değişkeni içerisine aktarilması sağlanmış oldu. [docker secret create](https://docs.docker.com/engine/reference/commandline/secret_create/)|
|`docker secret create sifre sifre.txt`| sifre.txt içerisindeki verinin sifre değişkeni içerisine aktarilması sağlanmış oldu.[docker secret create](https://docs.docker.com/engine/reference/commandline/secret_create/)|
|`docker secret ls`| yaratılan secret değişkenlerinin listelenmesi için kullanılır. [docker secret ls](https://docs.docker.com/engine/reference/commandline/secret_ls/)<br>![docker secret ls](/img/docker_secret_p1.png)|
|`docker secret inspect kullanici_adi`<br><br>`docker secret inspect sifre`| belirtilen secret anahtarına ait detaylı bilgileri gösterir. [docker secret inspect](https://docs.docker.com/engine/reference/commandline/secret_inspect/) <br><br> ![docker secret inspect](/img/docker_secret_p1.png)|
|`echo "Bu diğer komuta secret atamasidir" \| docker secret create deneme -`| Direckt olarak secret deyimine şifrelenecek içeriğin aktarılması ![docker secret](/img/docker_secret_p3.png)|
|`docker service create --name secrettest --secret kullanici_adi --secret sifre --secret deneme esaydam/phpweb`| docker swarm modunda olan manager node üzerinde komut çalıştırıldığında yaratılan service ile ilgili oluşturulan container içerisinde `/run/secrets/` klasörü altında secretlar dosya olarak oluştururlurlar. ![docker service create](/img/docker_secret_p4.png)|
|`docker service update --secret-rm sifre --secret-add sifre2 secrettest`|secretların değiştirilerek tekrar kullanımının sağlanması ![docker service update](/img/docker_secret_p5.png)|
## NOT: Daha önceden oluşturulmuş bir secret içeriği değiştirilemez. Ancak yeni bir secret eklenip yaratılan service üzerinde update edilerek eski secret silinir yeni secret eklenerek yeni oluşturulan secret kullanılabilir.
