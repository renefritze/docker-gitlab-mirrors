FROM alpine:3.15
MAINTAINER René Fritze <coding@fritze.me>

ENV GITLAB_MIRROR_ASSETS=/assets \
	GITLAB_MIRROR_USER=git \
	GITLAB_MIRROR_HOME=/config \
	GITLAB_MIRROR_INSTALL_DIR=/opt/gitlab-mirror \
	GITLAB_MIRROR_REPO_DIR=/data \
	GITLAB_MIRROR_VERSION=0.6.1

RUN apk update \
	&& apk add bash git gettext git-svn mercurial python3 py3-pip openssl \
		sudo perl-git openssh-client \
	&& pip3 install python-gitlab \
	&& rm -rf /var/cache/apk/*

WORKDIR /
RUN git clone --branch=main --depth 1 https://github.com/renefritze/gitlab-mirrors.git \
    ${GITLAB_MIRROR_INSTALL_DIR}

RUN echo 'env_keep+=SSH_AUTH_SOCK' >> /etc/visudo

COPY assets ${GITLAB_MIRROR_ASSETS}
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

VOLUME ["${GITLAB_MIRROR_REPO_DIR}", "${GITLAB_MIRROR_HOME}"]
WORKDIR ${GITLAB_MIRROR_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["help"]
