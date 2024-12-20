FROM mcr.microsoft.com/devcontainers/base:ubuntu24.04
RUN export DEBIAN_FRONTEND=noninteractive && \
    (wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg) && \
    (echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list) && \
    apt-get update && apt -y upgrade && \
    apt install terraform && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*