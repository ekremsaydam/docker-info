# [KUBERNETES INSTALATION](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

`sudo su` <br><br>
`sudo apt-get update` <br><br>
`sudo apt-get install -y apt-transport-https ca-certificates curl` <br><br>
`sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg` <br><br>
`echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list` <br><br>
`sudo apt-get update`<br><br>
`sudo apt-get install -y kubelet kubeadm kubectl`<br><br>
`sudo apt-mark hold kubelet kubeadm kubectl`

# [kubectl bash auto-completion on Linux](https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/)

`kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null`


# [minikube Instalation](https://minikube.sigs.k8s.io/docs/start/)
`sudo su` <br><br>
`curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb` <br><br>
`sudo dpkg -i minikube_latest_amd64.deb` \
`exit` \
`minikube start` \
`kubectl get po -A` \
`minikube kubectl -- get po -A`

    alias kubectl="minikube kubectl --"

`minikube dashboard`

# [minikube bash auto-completion on Linux](https://minikube.sigs.k8s.io/docs/commands/completion/)
`echo 'source <(minikube completion bash)' >>~/.bashrc`

# minikube env host docker env olarak kullanılması
`docker container ls` \
`minikube docker-env` \
`eval $(minikube docker-env)` \
`docker container ls`