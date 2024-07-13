#!/bin/bash

using_kubernetes=$3
using_ui=$4
using_docker_ui_test=$5

if [ "$using_kubernetes" = true ]; then
  kubectl delete service docker-registry --grace-period=0 --force
  kubectl delete deployment docker-registry --grace-period=0 --force
  kubectl delete pods -l app=docker-registry --grace-period=0 --force
  kubectl delete pvc docker-registry-data-pv-claim --grace-period=0 --force
  kubectl delete pvc docker-registry-auth-pv-claim --grace-period=0 --force
  kubectl delete pv docker-registry-data-pv --grace-period=0 --force
  kubectl delete pv docker-registry-auth-pv --grace-period=0 --force
  if [ "$using_ui" = true ]; then
    if [ "$using_docker_ui_test" = true ]; then
      ui=true
    else
      kubectl delete service docker-registry-ui --grace-period=0 --force
      kubectl delete deployment docker-registry-ui --grace-period=0 --force
    fi
  fi
else
  sudo docker rm $(sudo docker stop $(sudo docker ps -a -q --filter ancestor=registry:2.7 --format="{{.ID}}"))
  if [ "$using_ui" = true ]; then
    ui=true
  fi
fi
if [ "$ui" = true ]; then
  sudo docker rm $(sudo docker stop $(sudo docker ps -a -q --filter ancestor=konradkleine/docker-registry-frontend:v2 --format="{{.ID}}"))
fi

sudo rm -r ~/docker-registry
