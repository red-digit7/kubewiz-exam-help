#!/usr/bin/env bash

shopt -s expand_aliases
set -e
DIR=$(dirname $(realpath $BASH_SOURCE))

function loadEnv() {
  source $DIR/../src/core.sh
  . ~/.bashrc
}

function testKubectlCompletion() {
  complete -p | grep "__start_kubectl kubectl" > /dev/null
}

function testKCompletion() {
  complete -p | grep "__start_kubectl k" > /dev/null
}

loadEnv
testKubectlCompletion
testKCompletion