#!/bin/bash

args=$@

execute() {
  sha=$(curl -sSL https://api.github.com/repos/WildePizza/docker-registry/commits?per_page=2 | jq -r '.[1].sha')
  curl -fsSL https://raw.githubusercontent.com/WildePizza/mysql-kubernetes/HEAD/.commits/$sha/install.sh | bash -s $args
  if [[ $? -ne 0 ]]; then
    execute
  fi
}
execute
