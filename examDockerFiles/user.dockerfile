FROM centos
RUN adduser newuser
USER newuser
CMD whoami