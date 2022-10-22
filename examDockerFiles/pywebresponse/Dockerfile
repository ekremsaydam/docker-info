FROM python:2
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://127.0.0.1:80/number || exit 1
ADD . /code
WORKDIR /code

RUN pip install -r requirements.txt
ARG WAIT_TIME
CMD gunicorn -b 0.0.0.0:80 responsewait:api