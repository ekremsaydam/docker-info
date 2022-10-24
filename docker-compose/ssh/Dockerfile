# base image
FROM ubuntu
# openssh-server kurulumu
RUN apt-get update && apt-get install -y openssh-server
# root password belirleniyor
RUN echo "root:parola" | chpasswd
# root kullanıcıs ile giriş yapılabilmesi için sshd_config ayarı değiştiriliyor.
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# 22 numaralı portun docker daemona iletilmesi
EXPOSE 22/tcp
# sshd çalışması için gerekli default klasör
RUN mkdir /var/run/sshd
# remote olarak sshfs kullanılarak bağlanılacak klasör yaratıldı
RUN mkdir /remote
# CMD ["/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
CMD ["/usr/sbin/sshd", "-D"]