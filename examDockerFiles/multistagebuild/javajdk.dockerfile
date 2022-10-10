FROM mcr.microsoft.com/java/jdk:8-zulu-alpine
WORKDIR /usr/src/app/
COPY app.java .
RUN javac app.java
CMD [ "java","app" ]