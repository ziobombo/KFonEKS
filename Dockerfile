FROM ubuntu:latest
LABEL Name=kfoneks Version=0.0.1

ENV AWS_CLUSTER_NAME=kfoneks
ENV AWS_REGION=us-west-2
ENV K8S_VERSION=1.19
ENV EC2_INSTANCE_TYPE=m5.large
ENV KF_USERNAME=server0
ENV KF_PASSWORD="ja-s22 am-v1200"

RUN mkdir /config /app

# some dependencies
RUN apt-get -y update && apt-get install -y apt-transport-https ca-certificates curl
RUN DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris apt-get -y install tzdata

# kubectl & awscli
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get -y update && apt-get install -y kubectl awscli

#eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /usr/bin

#aws-iam-authenticator
RUN curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x /usr/bin/aws-iam-authenticator

# kfctl
RUN curl --silent --location "https://github.com/kubeflow/kfctl/releases/download/v1.2.0/kfctl_v1.2.0-0-gbc038f9_linux.tar.gz" | tar xz -C /usr/bin
ENV CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.2-branch/kfdef/kfctl_aws.v1.2.0.yaml"
RUN mkdir /config/${AWS_CLUSTER_NAME}
RUN curl -o /config/${AWS_CLUSTER_NAME}/kfctl_aws.yaml ${CONFIG_URI}
RUN sed -i 's/us-west-2/'"${AWS_REGION}"'/g' /config/${AWS_CLUSTER_NAME}/kfctl_aws.yaml
RUN sed -i 's/admin@kubeflow.org/'"${KF_USERNAME}"'/g' /config/${AWS_CLUSTER_NAME}/kfctl_aws.yaml
RUN sed -i 's/12341234/'"${KF_PASSWORD}"'/g' /config/${AWS_CLUSTER_NAME}/kfctl_aws.yaml


COPY aws /root/.aws

COPY config/cluster.yaml /config
RUN sed -i 's/AWS_CLUSTER_NAME/'"${AWS_CLUSTER_NAME}"'/g' /config/cluster.yaml
RUN sed -i 's/K8S_VERSION/'"${K8S_VERSION}"'/g' /config/cluster.yaml
RUN sed -i 's/AWS_REGION/'"${AWS_REGION}"'/g' /config/cluster.yaml
RUN sed -i 's/EC2_INSTANCE_TYPE/'"${EC2_INSTANCE_TYPE}"'/g' /config/cluster.yaml

COPY install.sh /app
RUN sed -i 's/AWS_CLUSTER_NAME/'"${AWS_CLUSTER_NAME}"'/g' /app/install.sh

RUN chmod +x /app/install.sh

#CMD ["/app/install.sh"]