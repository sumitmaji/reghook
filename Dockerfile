FROM ubuntu:xenial

LABEL sum.label-schema.vcs-url="https://github.com/sumitmaji/reghook.git"


RUN apt-get update \
&& apt-get install -y curl wget\
&& curl -sL https://deb.nodesource.com/setup_8.x | bash - \
&& wget -q https://dl.k8s.io/v1.10.0/kubernetes-client-linux-amd64.tar.gz -O /tmp/kubernetes-client-linux-amd64.tar.gz \
&& tar -xzvf /tmp/kubernetes-client-linux-amd64.tar.gz -C /tmp/ \
&& cp /tmp/kubernetes/client/bin/kubectl /usr/local/bin/kubectl \
&& rm -rf /tmp/* \
&& chmod +x /usr/local/bin/kubectl \
&& wget https://kubernetes-helm.storage.googleapis.com/helm-v2.8.2-linux-amd64.tar.gz -O /tmp/helm-v2.8.2-linux-amd64.tar.gz \
&& tar -xzvf /tmp/helm-v2.8.2-linux-amd64.tar.gz -C /tmp/ \
&& cp /tmp/linux-amd64/helm /usr/local/bin/helm \
&& chmod +x /usr/local/bin/helm \
&& apt-get install -y \
nodejs \
git \
socat \
build-essential \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN node -v

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY server/package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

COPY server/index.js .


RUN mkdir -p scripts
ADD scripts/build.sh scripts/build.sh
RUN chmod +x scripts/build.sh
ADD rbac.yaml scripts/rbac.yaml
ADD setup.sh scripts/setup.sh
RUN chmod +x scripts/setup.sh

EXPOSE 5003

ENTRYPOINT [ "./scripts/setup.sh" ]
