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
imajların oluşumu sırasında belirtilen komutları çaıştırır.
İki farklı formu vardır.
1. `RUN <command>`
2. `RUN ["executable", "param1", "param2"]`

İlk formu kullanılacak ise escape `\` karakteri kullanılarak birden fazla satır komut çalıştırılabilir.

**NOT**: *Birden çok satırda RUN kullanmak yerine tek bir satırda RUN ifadesi kullanılması doğru bir yaklaşımdır. Birden fazla satırda RUN ifadesi kullanılması imajın oluşturulduğu katman sayısını artıracaktır.*

İkinci formu kullanılacaksa **çift tırnak** `"` kullanıldığına dikkat edin.

**NOT**: *ikinci formun kullanıldığı noktalarda çift tırnak içerisinde `\` kullanılacak ise `\\` olarak kullanılması gerekmektedir.*

## [CMD](https://docs.docker.com/engine/reference/builder/#cmd)
CMD dockerfile içerisinde sadece 1 kez kullanılabilir. Birden fazla kullanımlarda sadece son kullanılan CMD satırı çalışacaktır.
Üç formu vardır.
1. `CMD ["executable","param1","param2"]`
2. `CMD ["param1","param2"]`
3. `CMD command param1 param2`

## [ADD](https://docs.docker.com/engine/reference/builder/#add)
İki formu vardır.
1. `ADD [--chown=<user>:<group>] <src>... <dest>`
2. `ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]`

`--chown=` parametresi sadece linux kullanıcıları için geçerlidir.

`src` olarak belirtilen dosyayı image içerisine `dest` olarak belirtilen pathe kopyalar.

**NOT**:*COPY komutundan farklı ADD tar dosyaları ve URL üzerinden de işlem yapabilir."*


## ORNEK

| Command        | Description |
| -------------- | ----------- |
| `docker build --tag mycentos:v1 .` <br><br> `docker build -t mycentos:v2 .` <br><br>`docker build --tag mycentos:v1 --file mynewcentos .`<br><br>`docker build -t mycentos:v1 -f mynewcentos .`| dockerfile build alıp image oluşturmak için kullanılır. [docker build](https://docs.docker.com/engine/reference/commandline/build/)|

