# DOCKER IMAGE REGISTRY
Docker imajları varsayılan olarak [hub.docker.com](https://hub.docker.com/_/registry) bulunmakta ve buradan çekilmektedir. Ayrıca [Google Cloud Registry](https://console.cloud.google.com/gcr/images/google-containers) ve [Microsoft Artifact Registry](https://mcr.microsoft.com/en-us/) gibi online ve herkesin erişebildiği image listeleri bulunmaktadır.

Docker image lerimizin başkaları tarafından erişilmesini istemiyorsak Docker Enterprise Edition ve AWS gibi sistemler kullanmalı ve belli bir ücret ödemesi yapılması gereklidir.

Ücretsiz olarak kullanabileceğimiz [hub.docker.com](https://hub.docker.com/_/registry) üzerinden ulaşabileceğimiz Registery ile ağımıza özel local image deposu oluşturabiliriz.

`docker pull registry`\
`docker run -d -p 5000:5000 --restart always --name registry registry`

Bu kurulum yapıldıktan sonra http://host.docker.internal:5000/ (host.docker.internal benim docker host makinemin ip adresine yönlendirilmiştir.) adresi üzerinden erişilebilir. Ancak boş bir web sayfası şeklinde görüntülenecektir.

Herhangi bir local registry üzerinde repository bulunup bulunmadığını görüntülemek için http://host.docker.internal:5000/v2/_catalog adresi kullanılabilir. (/v2/_catalog)\
![docker registry](/img/docker_registry_p1.png)

`docker image tag workimage:latest 127.0.0.1:5000/workimage:latest`
![docker registry](/img/docker_registry_p3.png)

Yukarıdaki docker image tag komutu ile docker host üzerinde bulunan bir image yi farklı bir tag ile isimlendirmek için kullanıyoruz. Burada yapılan bulunmasını istediğimiz registry altında varolan image yi tag lemek.

`docker image push 127.0.0.1:5000/workimage`

Yukarıdaki komut ilede local image registry mize image mizi gönderiyoruz. Tekrar http://host.docker.internal:5000/v2/_catalog adresine baktığımızda image miz repository de görüntülenecektir.

![docker registry](/img/docker_registry_p2.png)