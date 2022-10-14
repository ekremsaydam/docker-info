FROM php:8.0-apache
# image metadatasının tanımlanması
LABEL maintainer="Firstname Lastname @firtlast"  version="1.0" name="hello-docker"

RUN mkdir /var/www/html/images && chmod 777 /var/www/html/images
WORKDIR /var/www/html/
COPY helloworld.html .
RUN apt-get update && apt-get upgrade && apt-get install -y curl mariadb-client
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# nginx çalıştığının kontrolü
# --intervall : Her 30 saniyede bir kontrol yapılacak
# --timeout : Eğer komutun sonucu 10 saniye içerisinde dönmezse unhealth
# --start-period : 5 saniye bekle heathcheck çalışsın
# --retries : kaç denemede başarısız olursa unhelth olarak işaretle
HEALTHCHECK --interval=30s \
    --timeout=10s \
    --start-period=5s \
    --retries=3 \
    CMD curl -f http://localhost || exit 1
# || öncesindeki komutu çalıştır hata dönerse sonrasındaki kodu çalıştır. Hata dönmezse exit 1 çalışmaz.

# sed : helloworld.html içerisinde Kullanici kelimesi geçitiği yerleri $KULLANICI ENV içerisindeki bilgi ile değiştir ve index1.html olarak kaydet.
# sed : index1.html içerisinde Hostname kelimesi geçen yerleri HOSTNAME variable ile değiştir ve index.html olarak değiştir.
ARG VERSION="LATEST" KULLANICI="User(Kullanıcı)"

RUN sed -e s/Kullanici/"$KULLANICI"/ helloworld.html > index2.html \
    && sed -e s/Version/"${VERSION}"/ index2.html > index1.html; \
    rm index2.html helloworld.html;
CMD sed -e s/Hostname/"$HOSTNAME"/ index1.html > index.html \
    && apache2-foreground
# nginx -g 'daemon off' : nginx daemon ı çalıştırmak.

# RUN : image oluşturma aşamasında çalışır.
# CMD : container oluşturma aşamasında çalışır.