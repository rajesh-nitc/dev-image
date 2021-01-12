FROM gcr.io/google.com/cloudsdktool/cloud-sdk:latest
LABEL maintainer "Rajesh Gupta <rajesh.nitc@gmail.com>"

ARG TERRAFORM_VERSION=0.14.4
ARG TERRAFORM_DOCS_VERSION=0.10.1

RUN set -xe && \
    # apt-get update && \
    # install packages
    apt-get install -y \
    unzip \
    jq \
    sudo \
    net-tools \
    dos2unix && \ 
    # install terraform
    curl -k https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_linux_amd64.zip && \
    unzip terraform_linux_amd64.zip && mv terraform /usr/local/bin/ && \
    rm -r terraform_linux_amd64.zip && \
    # install terraform-docs
    curl -k -Lo ./terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    chmod +x ./terraform-docs && \
    mv terraform-docs /usr/local/bin && \
    # update ca-certificates
    openssl s_client -showcerts -servername github.com -connect github.com:443 </dev/null 2>/dev/null | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'  > github-com.pem && \
    cat github-com.pem | tee -a /etc/ssl/certs/ca-certificates.crt && \
    rm github-com.pem

RUN useradd -ms /bin/bash rajesh && echo "rajesh:rajesh" | chpasswd && adduser rajesh sudo
USER rajesh
WORKDIR /home/rajesh

# COPY entrypoint.sh ./entrypoint.sh
# RUN chmod +x ./entrypoint.sh
# ENTRYPOINT ["./entrypoint.sh"]
