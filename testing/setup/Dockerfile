FROM debian:bullseye-slim
LABEL "maintainer"="https://github.com/ReinierNel/relayctl"

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl whiptail locales locales-all openssl
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /testing

ADD setup.sh /testing/setup.sh
RUN chmod +x /testing/setup.sh
RUN groupadd gpio

CMD /testing/setup.sh test