FROM alpine

LABEL version="1.0.0"
LABEL repository="https://github.com/rkusa/keel-webhook-action"
LABEL homepage="https://github.com/rkusa/keel-webhook-action"
LABEL maintainer="Markus Ast <m@rkusa.st>"

LABEL com.github.actions.name="Keel Webhook"
LABEL com.github.actions.description="Send an (Docker image) update notification to a Keel (keel.sh) webhook endpoint."
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="gray-dark"

RUN apk add --no-cache --update curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]