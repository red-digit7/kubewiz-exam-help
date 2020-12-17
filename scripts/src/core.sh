#!/usr/bin/env bash

wget -q https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -P ~/

cat <<EOKUBEWIZCORE >> ~/.kubewiz-core.sh
source <(kubectl completion bash)
alias k=kubectl
alias kn='kubectl config set-context --current --namespace'
alias kdr='k --dry-run=client -o=yaml'
alias kdf='k delete --grace-period=0 --force'
alias krf='k replace --force --grace-period 0 -f'
alias kbb='kubectl run busybox-test --image=busybox -it --rm --restart=Never --'
complete -F __start_kubectl k
complete -F __start_kubectl kdr
complete -F __start_kubectl kn
complete -F __start_kubectl kdf
complete -F __start_kubectl krf
export KUBE_EDITOR=vim
export ETCDCTL_API=3
source ~/kube-ps1.sh
PS1='[\u@\h \W \$(kube_ps1)]\$ '
EOKUBEWIZCORE

cat <<EOBASHRC >> ~/.bashrc
. ~/.kubewiz-core.sh
EOBASHRC

cat <<EOVIMRC >> ~/.vimrc
set tabstop=2
set expandtab
set shiftwidth=2
EOVIMRC
