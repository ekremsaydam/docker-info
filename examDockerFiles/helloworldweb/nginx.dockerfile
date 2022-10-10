FROM nginx:latest
# image metadatasının tanımlanması
LABEL maintainer="Firstname Lastname @firtlast"  version="1.0" name="hello-docker"

# environment variable
ENV KULLANICI="administrator"

RUN apt-get update && apt-get install curl -y

WORKDIR /usr/share/nginx/html

COPY helloworld.html /usr/share/nginx/html

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
CMD sed -e s/Kullanici/"$KULLANICI"/ helloworld.html > index1.html \
    && sed -e s/Hostname/"$HOSTNAME"/ index1.html > index.html; \
    rm index1.html helloworld.html; \
    nginx -g 'daemon off;'
# nginx -g 'daemon off' : nginx daemon ı çalıştırmak.

# RUN : image oluşturma aşamasında çalışır.
# CMD : container oluşturma aşamasında çalışır.