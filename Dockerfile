FROM ubuntu:18.04

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN sed -i "s/archive.ubuntu.com/mirrors.cloud.tencent.com/g" /etc/apt/sources.list
RUN sed -i "s/security.ubuntu.com/mirrors.cloud.tencent.com/g" /etc/apt/sources.list
RUN apt update -y && apt install python3-pip git -y && pip3 install --no-cache-dir pipenv

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pip3 install --no-cache-dir -r <(pipenv lock -r)"

ADD . /httpbin
RUN pip config set global.index-url http://mirrors.cloud.tencent.com/pypi/simple \
&& pip config set global.trusted-host mirrors.cloud.tencent.com
RUN pip3 install --no-cache-dir /httpbin
RUN pip3 install gunicorn

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]
