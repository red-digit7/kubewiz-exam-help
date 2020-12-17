# KubeWiz Exam Help

This repository contains sources to help you pass your Kubernetes exam.
## Configure shell for productivity

> :warning: This setup procedure works for your practice sessions but you will not be able to use it in the exam. Linux Foundation interprets this command as access to web resources outside of the allowed list. We are working on delivering this setup in a way that is compliant with Linux Foundation rules. In the meantime, memorize the aliases you find useful and set your shell manually at the beginning of your exam.

Initialize your shell with `kubectl` completion, shortcuts and prompt. The configuration will be persisted in your `.bashrc` so you only have to do it once in a new environment:

```
wget -q http://sh.kubewiz.com/core -O - | sh; exec bash
```

The command loads `./scripts/core.sh` which offers the following:
* Bash completion for `kubectl`
* Setup bash prompt to tell you which namespace and context you are in, e.g.:
  ```
  [k8s@k8s ~ (⎈ |k8s:default)]$ kn kube-system
  Context "k8s" modified.
  [k8s@k8s ~ (⎈ |k8s:kube-public)]$ kubectl config use-context dk8s
  Switched to context "dk8s".
  [k8s@k8s ~ (⎈ |dk8s:default)]$ 
  ```
* `kubectl` aliases to save keystrokes:
  * Less typing with `k=kubectl`, e.g.:
    ```
    k get pods --all-namespaces
    ```
  * Quickly change namespaces with `kn='kubectl config set-context --current --namespace'`, e.g.:
    ```
    kn api-ns
    ```
  * Generate yaml using `kdr='k --dry-run=client -o=yaml'`, e.g.:
    ```
    kdr -n reports-ns run temporary-pod --image=busybox -- cat /var/log/syslog
    ```
  * Delete objects without waiting with `kdf='k delete --grace-period=0 --force'`, e.g.:
    ```
    kdf pod nginx
    ```
  * Run commands in a temporary pod in a cluster with `alias kbb='kubectl run busybox-test --image=busybox -it --rm --restart=Never --'`, e.g.:
    ```
    kbb wget -qO- -T 3 http://api-app.api-ns
    ```


