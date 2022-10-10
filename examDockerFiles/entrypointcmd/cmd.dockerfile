FROM mcr.microsoft.com/java/jre:8-zulu-alpine
WORKDIR /app
COPY .\ .
CMD [ "java", "-cp", "./", "App" ]