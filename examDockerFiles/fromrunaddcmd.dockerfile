FROM centos
RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && yum update -y && yum install wget git -y
ADD https://raw.githubusercontent.com/ekremsaydam/docker/master/README.md /home/README.md
CMD tail /home/README.md