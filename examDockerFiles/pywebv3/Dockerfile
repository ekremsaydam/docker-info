FROM python:alpine
STOPSIGNAL SIGHUP
# STOPSIGNAL SIGKILL
COPY index.html /
EXPOSE 9000
CMD python3 -m http.server 9000