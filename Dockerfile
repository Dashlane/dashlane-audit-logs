FROM ubuntu:24.04

COPY src/entrypoint.sh /opt/entrypoint.sh
COPY src/fluentbit-default.conf /opt/fluent-bit.conf

RUN apt-get update && \
    apt-get install -y curl jq gnupg && \
    curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor > /usr/share/keyrings/fluentbit-keyring.gpg &&\
    curl https://github.com/Dashlane/dashlane-cli/releases/download/v6.2415.0/dcli-linux-x64 -L > /usr/local/bin/dcli && \ 
    curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh && \
    chmod a+x /usr/local/bin/dcli

RUN groupadd -g 61000 user && useradd -g 61000 -l -M -s /bin/false -u 61000 user

ENV DASHLANE_CLI_FLUENTBIT_CONF="/opt/fluent-bit.conf"
ENV DASHLANE_CLI_RUN_DELAY=60

USER user

CMD [ "/bin/bash", "/opt/entrypoint.sh" ]
