FROM alpine:latest
WORKDIR /app
#COPY wordpress-6.0.2.tar.gz .
ADD wordpress-6.0.2.tar.gz .
ADD https://wordpress.org/latest.tar.gz .
