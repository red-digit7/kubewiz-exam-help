#!/usr/bin/env bash

shopt -s expand_aliases
set -e
DIR=$(dirname $(realpath $BASH_SOURCE))

function loadEnv() {
  source $_DIR/../src/core.sh
  . ~/.bashrc
}

function testKubectlCompletion() { 
}

loadEnv
testKubectlCompletion