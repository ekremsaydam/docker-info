FROM mcr.microsoft.com/java/jdk:8-zulu-alpine AS compiler
WORKDIR /usr/src/app/
COPY app.java .
RUN javac app.java

FROM mcr.microsoft.com/java/jre:8-zulu-alpine
WORKDIR /usr/src/app/
COPY --from=compiler /usr/src/app/app.class .
CMD [ "java","app" ]
