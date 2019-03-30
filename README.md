# Keel Webhook Github Action

This Action runs can be used to notify [Keel](https://keel.sh) about docker image updates (using [Keel's webhook endpoint](https://keel.sh/v1/guide/documentation.html#Webhooks). This action is meant to be used in conjunction with the [Docker Tag action](https://github.com/actions/docker/tag).

## Usage

It is **important** to run `actions/docker/tag` prior to exucting the `keel-webhook-action`, because the `keel-webhook-action` uses the `$IMAGE_REF` pushed by `actions/docker/tag`.

```hcl
workflow "Update Docker Image" {
  on = "push"
  resolves = [
    "Send Keel notifications",
  ]
}

action "Docker Build" {
  uses = "actions/docker/cli@master"
  args = "build -t your-image ."
}

action "Docker Tag" {
  uses = "actions/docker/tag@master"
  needs = ["Docker Build"]
  args = "--no-sha --no-latest --env your-image your-registry.com/your-image"
}

action "Docker Login" {
  uses = "actions/docker/login@master"
  needs = ["Docker Tag"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Push" {
  uses = "actions/docker/cli@master"
  needs = ["Docker Login"]
  args = "push your-registry.com/your-image"
}

action "Send Keel notifications" {
  uses = "rkusa/keel-webhook-action"
  needs = ["Docker Push"]
  args = "your-registry.com/your-image"
  secrets = ["KEEL_USERNAME", "KEEL_PASSWORD"]
  env = {
    KEEL_WEBHOOK_URL = "https://keel.your-server.com/"
  }
}

```

### Secrets

* `KEEL_USERNAME` and `KEEL_PASSWORD` - **Required**. The basic authentication username and password used to access your Keel endpoint.

### Environment variables

* `KEEL_WEBHOOK_URL` - **Required**. The URL to your Keel installation.

#### Example

Send notification for one image ...

```hcl
action "Send Keel notifications" {
  uses = "rkusa/keel-webhook-action"
  args = "your-registry.com/your-image"
  secrets = ["KEEL_USERNAME", "KEEL_PASSWORD"]
  env = {
    KEEL_WEBHOOK_URL = "https://keel.your-server.com/"
  }
}
```

... or for multiple images

```hcl
action "Send Keel notifications" {
  uses = "rkusa/keel-webhook-action"
  args = "your-registry.com/first-image your-registry.com/second-image"
  secrets = ["KEEL_USERNAME", "KEEL_PASSWORD"]
  env = {
    KEEL_WEBHOOK_URL = "https://keel.your-server.com/"
  }
}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

Container images built with this project include third party materials. As with all Docker images, these likely also contain other software which may be under other licenses. It is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.