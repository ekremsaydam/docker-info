FROM centos
RUN adduser newuser
WORKDIR /home/
CMD pwd
