FROM node:alpine

RUN npm install -g sqslite@2.1.1

RUN apk add --no-cache aws-cli bash

RUN wget -O /usr/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
  chmod a+x /usr/bin/wait-for-it

ENV HOME /home/sqs

RUN mkdir -p $HOME && \
  addgroup  -g 1001 sqs && \
  adduser -G sqs -u 1001 -h $HOME -S sqs

COPY --chown=sqs .aws/ /home/sqs/.aws/
COPY entrypoint.sh /usr/bin/entrypoint

ARG VCS_URL
ARG VCS_REF

LABEL \
  maintainer="Alan Ghelardi <alan.ghelardi@gmail.com>" \
  org.label-schema.schema-version=1.0 \
  org.label-schema.vcs-url="$VCS_URL" \
  org.label-schema.vcs-ref="$VCS_REF"

USER 1001:1001
WORKDIR /home/sqs
ENTRYPOINT ["/bin/bash", "/usr/bin/entrypoint"]
