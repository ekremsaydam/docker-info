FROM mcr.microsoft.com/java/jre:8-zulu-alpine
WORKDIR /usr/src/app/
COPY --from=esaydam/javaappjdk /usr/src/app/app.class .
CMD [ "java","app" ]