# debian kurulumu üzerinden hareket edildi.
FROM debian:bullseye-slim
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
        iputils-ping \
        python3 \
        net-tools
WORKDIR /pythonfiles
COPY /pythonfiles/uygulama.py .
CMD ["python3","/pythonfiles/uygulama.py"]

