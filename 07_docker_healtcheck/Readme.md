
# Docker Healthchecks

- Healtcheckler 1.12 versiyonu ile eklendi
- Dockerfile, Swarm, Compose YAML ve Container ile kullanılabilir.
- Exec ile Container'a girdiğiniz. (örneğin, curl localhost)
    - Exit 0 : Sorun yok - OK
    - Exit 1 : Hata var - ERROR

- 3 Durum var
    - Starting : Başlıyor
    - Healthy : Hatasız Çalıştı
    - Unhealthy : Bir hata oluştu


## Yöntem 1 :
---
> ```docker container run --name es -d --health-cmd "curl -f localhost:9200 || exit 1" --health-interval 3s --health-timeout 5s elasticsearch:2```

Parametre | Anlamı
----------|--------
**--detach , -d**| _Containerın arka planda çalışmasını sağlar_ 
**--name**| _Container ismi_ 
**--health-cmd** |_aktif olup olmadığını sağlamak için kullanılacak komut_
**--health-interval** |_her belirtilen saniyede bir sağlık durum kontrolü komutu çalıştırılır._
**--health-retries** |_Sağlıksız olduğunu bildirmek için ardışık başarısız olma adedi belirtili. ._
**--health-start-period** |_Sağlık durumunu yeniden denemeye başlamadan önce kabın(containerın) başlatılması için başlangıç ​​süresi (ms-s-m-h) (varsayılan 0s)_
**--health-timeout** |_işlemin onayı için bekleme süresi sonu_


> ```docker container inspect es```

_Aşağıdaki gibi son 5 healtcheck görüntülenecektir._
```json
"State": {
    "Health": {
           "Log": [
                    {
                        "Start": "2019-01-15T20:59:36.5154432Z",
                        "End": "2019-01-15T20:59:36.606592Z",
                        "ExitCode": 0,
                        "Output": "  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\n                                 Dload  Upload   Total   Spent    Left  Speed\n\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r100   359  100   359    0     0  69158      0 --:--:-- --:--:-- --:--:-- 71800\n{\n  \"name\" : \"Vesta\",\n  \"cluster_name\" : \"elasticsearch\",\n  \"cluster_uuid\" : \"_IDKsU4dSMCxagf9pdlB7A\",\n  \"version\" : {\n    \"number\" : \"2.4.6\",\n    \"build_hash\" : \"5376dca9f70f3abef96a77f4bb22720ace8240fd\",\n    \"build_timestamp\" : \"2017-07-18T12:17:44Z\",\n    \"build_snapshot\" : false,\n    \"lucene_version\" : \"5.5.4\"\n  },\n  \"tagline\" : \"You Know, for Search\"\n}\n"
                    }
```


## Yöntem 2 : Dockerfile ile
---
```dockerfile
FROM nginx:latest
RUN apt-get update && apt-get install -y curl

HEALTHCHECK --interval=3s --timeout=3s CMD curl localhost || exit 1
EXPOSE 80
```

>__imajın hazırlanması__ : ```docker image build -t healthcheck-nginx:latest .```

>__imajın kurulması__ : ```docker container run --name hc -d healthcheck-nginx```

