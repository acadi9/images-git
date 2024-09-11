
# base Image 
FROM ubuntu:20.04

RUN apt update && apt upgrade -y && apt install -y zip unzip sudo wget curl

ARG UID=1001
ARG GID=1001
ARG UNAME=my-ec2-user

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

RUN useradd --uid $UID --create-home --shell /bin/bash -G sudo,root $UNAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# terraform_1.0.2
ENV TF_VERSION 1.9.5

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip

RUN mv terraform /usr/local/bin/
RUN terraform --version

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# 실행 부
WORKDIR /terraform
RUN terraform init

CMD ["/bin/bash"]

