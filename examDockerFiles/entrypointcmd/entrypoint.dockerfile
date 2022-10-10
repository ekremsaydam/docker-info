FROM mcr.microsoft.com/java/jre:8-zulu-alpine
WORKDIR /app
COPY .\ .
ENTRYPOINT [ "java", "-cp", "./", "App" ]