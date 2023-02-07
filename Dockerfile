FROM ubuntu:22.04 AS base

RUN apt-get update \
    && apt-get install -y make git-core cmake python-is-python3 python3 \
    curl sudo bzip2 wget xz-utils

ENV VITASDK=/usr/local/vitasdk
ENV PATH=$VITASDK/bin:$PATH

FROM base AS vdpm

RUN git clone https://github.com/vitasdk/vdpm \
    && cd vdpm \
    && ./bootstrap-vitasdk.sh \
    && ./install-all.sh

FROM base AS devcontainer

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create User
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Create bash_history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chmod -R 777 /commandhistory \
    && echo $SNIPPET >> "/home/$USERNAME/.bashrc"

# Create workspace directory
RUN mkdir /workspace \
    && chmod -R 777 /workspace

# Other tools
RUN apt-get update \
    && apt-get install -y vim bash-completion \
    && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O /etc/bash_completion.d/git-completion

USER ${USERNAME}

COPY --from=vdpm --chown=${USERNAME}:${USERNAME} /usr/local/vitasdk /usr/local/vitasdk
