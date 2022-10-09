FROM ubuntu:latest
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y net-tools iputils-ping python3
WORKDIR /pythonfiles
COPY /pythonfiles/uygulama.py .
CMD ["python3","/pythonfiles/uygulama.py"]

