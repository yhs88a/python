variable "OWNER" {
  default = "yhs88a"
}

variable "GROUP" {
  default = "python"
}

variable "FILE" {
  default = "python"
}

variable "BASE_VERSION" {
  default = ""
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["build"]
}

group "test" {
  targets = ["test-alpine", "test-debian"]
}

group "push" {
  targets = ["push-alpine", "push-debian"]
}

target "settings" {
  context = "."
  cache-from = [
    "type=gha"
  ]
  cache-to = [
    "type=gha,mode=max"
  ]
}

target "test-alpine" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = []
}

target "test-debian" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.debian"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = []
}

target "build" {
  inherits = ["settings"]
  output   = ["type=docker"]
  tags = [
    "${OWNER}/${FILE}",
    "${OWNER}/${FILE}:${TAG}",
  ]
}

target "push-debian" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.debian"
  output   = ["type=registry"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${OWNER}/${FILE}:${TAG}-${BASE_VERSION}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}-${BASE_VERSION}",
  ]
}

target "push-alpine" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine"
  output   = ["type=registry"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${OWNER}/${FILE}",
    "${OWNER}/${FILE}:${TAG}-alpine",
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}-alpine",
  ]
}
