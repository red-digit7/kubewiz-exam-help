#!/usr/bin/env bash

wget -q https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -P ~/

cat <<EOT >> ~/.bashrc
source <(kubectl completion bash)
alias k=kubectl
alias kn='kubectl config set-context --current --namespace '
alias kdr='k --dry-run=client -o=yaml '
alias kbb='kubectl run busybox-test --image=busybox -it --rm --restart=Never --'
complete -F __start_kubectl k
complete -F __start_kubectl kdr
complete -F __start_kubectl kn
export KUBE_EDITOR=mcedit
export ETCDCTL_API=3
source ~/kube-ps1.sh
PS1='[\u@\h \W \$(kube_ps1)]\$ '
EOT
