FROM debian:bullseye-slim
LABEL "maintainer"="https://github.com/ReinierNel/relayctl"

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl locales locales-all openssl jq
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /testing

ADD test-api-endpoints.sh /testing/test-api-endpoints.sh
RUN chmod +x /testing/test-api-endpoints.sh
RUN groupadd gpio

ENTRYPOINT ["/testing/test-api-endpoints.sh"]
