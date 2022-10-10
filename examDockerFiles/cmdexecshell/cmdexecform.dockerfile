FROM centos:latest
ENV ANAHTARDEGER="Environment Variable içerisindeki değer"
CMD ["echo","$ANAHTARDEGER"]