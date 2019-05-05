FROM ubuntu:latest
#FROM mesosphere/aws-cli

RUN apt-get update && apt-get install -y dnsutils curl jq
RUN apt-get install -y \
        python \
        python-pip \
        python-setuptools \
        groff \
        less \
    && pip --no-cache-dir install --upgrade awscli \
    && apt-get clean
ADD entrypoint.sh /entrypoint.sh
ADD job.sh /job.sh
RUN chmod +x /job.sh && chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh
