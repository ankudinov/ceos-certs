FROM mcr.microsoft.com/devcontainers/python:0-3.9-bullseye

# change this for every release
ARG _AVD_VERSION
ARG _CLAB_VERSION
ARG _ARTOKEN
ARG _AR_FILE_PATH

# install some basic tools inside the container
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sshpass \
    curl \
    iputils-ping \
    htop \
    tcpdump \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# switch user to vscode otherwise Ansible will be installed as root
USER vscode
ENV PATH=$PATH:/home/vscode/.local/bin
# install Ansible
ENV ANSIBLE_CONFIG="/workspaces/ceos-certs/ansible.cfg"
RUN pip3 install "ansible-core>=2.13.1,<2.14.0" \
    && pip3 install ansible-pylibssh \
    && ansible-galaxy collection install ansible.netcommon \
    && ansible-galaxy collection install arista.eos \
    # install community.general to support callback plugins in ansible.cfg, etc.
    && ansible-galaxy collection install community.general \
    # add community crypto for cert generation
    && ansible-galaxy collection install community.crypto

# install the latest containerlab and yamllint
RUN bash -c "$(curl -sL https://get.containerlab.dev)" -- -v ${_CLAB_VERSION}

# add ceos-lab image
RUN ARTOKEN=$(echo -n "${_ARTOKEN}" | base64) \
    && ARSESSION=$(curl -X "POST" "https://www.arista.com/custom_data/api/cvp/getSessionCode/" -H 'Content-Type: application/json'   -d "{\"accessToken\": \"$ARTOKEN\"}" | sed -n 's|.*"session_code":"\([^"]*\)".*|\1|p') \
    && FILE_PATH=${_AR_FILE_PATH} \
    && DOWNLOAD_URL=$(curl -X "POST" "https://www.arista.com/custom_data/api/cvp/getDownloadLink/" -H 'Content-Type: application/json' -d "{\"sessionCode\": \"$ARSESSION\", \"filePath\": \"$FILE_PATH\"}" | sed -n 's|.*"url":"\([^"]*\)".*|\1|p') \
    && mkdir -p /home/vscode/tmp \
    && curl "$DOWNLOAD_URL" --output /home/vscode/tmp/ceos-lab-temp
