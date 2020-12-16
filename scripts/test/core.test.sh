#!/usr/bin/env bash

shopt -s expand_aliases
set -e
DIR=$(dirname $(realpath $BASH_SOURCE))

loadEnv() {
  echo "leading $DIR/../src/core.sh"
  source $DIR/../src/core.sh
  echo "source $DIR/../src/core.sh returned $?"

  echo "reloading . ~/.bashrc"
  . ~/.bashrc
  echo ". ~/.bashrc returned $?"
}

testCompletionForKubectl() {
  complete -p | grep "__start_kubectl kubectl$"
  assertEquals 0 $?
}

testCompletionForK() {
  complete -p | grep "__start_kubectl k$"
  assertEquals 0 $?
}

testCompletionForKdr() {
  complete -p | grep "__start_kubectl kdr$"
  assertEquals 0 $?
}

testKubeEditorEnv() {
  if [[ -z "${KUBE_EDITOR}" ]]; then
    fail "KUBE_EDITOR is not defined"
  else
    assertEquals vim $KUBE_EDITOR
  fi
}

testEtcdctlEnv() {
  if [[ -z "${ETCDCTL_API}" ]]; then
    fail "ETCDCTL_API is not defined"
  else
    assertEquals 3 $ETCDCTL_API
  fi
}

testPS1() {
  assertContains "$PS1" kube_ps1
}

testAliasForK() {
  ANS=`eval "k get nodes"`
  assertEquals 0 $?
  assertContains "$ANS" minikube 
}

testAliasForKn() {
  eval "kn default"
  assertEquals 0 $?
  assertEquals default `kubectl config view --minify --output 'jsonpath={..namespace}'`

  eval "kn kube-system"
  assertEquals 0 $?
  assertEquals kube-system `kubectl config view --minify --output 'jsonpath={..namespace}'`

  eval "kn default"
  assertEquals 0 $?
  assertEquals default `kubectl config view --minify --output 'jsonpath={..namespace}'`

}

testAliasForKdr() {
  ANS=`eval "kdr run nginx --image nginx"`
  assertContains "$ANS" "kind: Pod"
  assertContains "$ANS" "image: nginx"
  assertContains "$ANS" "name: nginx"
}

testAliasForKdf() {
  kubectl delete pod nginx
  eval "k run nginx --image nginx" && \
  eval "kdf pod nginx"
  eval "k get pod nginx"
  assertEquals 1 $?
}

testAliasForKrf() {
  tmpfile=$(mktemp /tmp/testAliasForKrf.XXXXXX)
  kubectl delete pod mypod
  eval "k run mypod --image nginx" && \
  eval "kdr run mypod --image httpd > $tmpfile" && \
  eval "krf $tmpfile" 
  ANS=`eval "kubectl get pod mypod -o=jsonpath='{..image}' | cut -d' ' -f 1"`
  rm $tmpfile || true
  eval "kdf pod mypod" || true
  assertEquals httpd "$ANS"
}

testAliasForKbb() {
  kubectl delete pod mypod
  eval "k run mypod --image nginx" 
  kubectl wait --timeout=30s --for=condition=Ready pod/mypod
  POD_IP=`kubectl get pod mypod -o custom-columns=IP:.status.podIP --no-headers`
  echo "IP of the test pod is $POD_IP"
  eval "kbb wget -qO- -T 3 http://$POD_IP"
  assertEquals 0 $?
}

loadEnv

. $DIR/../dependencies/shunit2