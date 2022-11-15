# 1. KUBERNETES INSTALATION

hostname değiştirmek için aşağıdaki komutlar kullanılır.
```
sudo vi /etc/hostname
```
```
sudo vi /etc/hosts
```
```
sudo hostnamectl set-hostname <new-hostname> --pretty
sudo hostnamectl set-hostname <new-hostname>
```
```
sudo sysctl --system
```

## 1.1 [Installing kubeadm, kubelet and kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime)

```
sudo apt-get update
```
```
sudo apt-get install -y apt-transport-https ca-certificates curl
```
```
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```

```
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
```
sudo apt-get update
```
```
sudo apt-get install -y kubelet kubeadm kubectl
```
```
sudo apt-mark hold kubelet kubeadm kubectl
```
```
kubectl version --client --output=yaml && kubeadm version --output=yaml
```

## 1.2 [kubectl bash auto-completion on Linux](https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/)

```
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
``` 

veya
benim tercihim

```
$ echo 'source <(kubectl completion bash)' >>~/.bashrc
$ sudo sysctl --system
```

## 1.3 kubeadm bash auto-completion on Linux

```
$ echo 'source <(kubeadm completion bash)' >>~/.bashrc
$ sudo sysctl --system
```

# 2. KUBERNETES CLUSTER INSTALATION
[Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
## 2.1. Disable Swap Space

```
$ free -h
$ sudo swapoff -a -v
$ sudo rm /swapfile
$ sudo cp /etc/fstab /etc/fstab.bak
$ sudo cat /etc/fstab
$ sudo sed -i '/\/swapfile/d' /etc/fstab
$ sudo cat /etc/fstab
$ sudo sysctl --system
```
vi kullanılamaz ise aşağıdaki gedit editörü ile değişiklik yapılabilir.
`$ sudo gedit /etc/fstab` \

## 2.2. Forwarding IPv4 and letting iptables see bridged traffic
[Forwarding IPv4 and letting iptables see bridged traffic](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#forwarding-ipv4-and-letting-iptables-see-bridged-traffic)
```
$ cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

```
$ sudo modprobe overlay
$ sudo modprobe br_netfilter
```

```
$ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
```

```
$ sudo sysctl --system
```
Kontrol etmek için aşağıdaki kod kullanılır.
```
$ lsmod | grep br_netfilter
```
## 2.3. Setting up Docker for Kubernetes
## 2.3.1. Setting up Docker for Kubernetes
[docker install](https://docs.docker.com/engine/install/ubuntu/)
```
$ sudo apt-get update
$ sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
$ sudo mkdir -p /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt-get update
$ sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
$ sudo docker version

$ sudo systemctl status docker
$ sudo service docker start
$ sudo apt-get install -y uidmap
$ dockerd-rootless-setuptool.sh install
$ docker context use rootless
$ sudo usermod -aG docker $USER
$ sudo systemctl daemon-reload 
$ sudo systemctl restart docker
$ sudo systemctl enable docker
$ sudo systemctl status docker
```

## 2.3.2. Setting up cri-dockerd on Docker for Kubernetes
[cri-dockerd](https://github.com/Mirantis/cri-dockerd)
```
$ systemctl status docker
$ sudo apt-get update
$ sudo apt-get install -y git wget curl
$ mkdir crid
$ cd crid
$ git clone https://github.com/Mirantis/cri-dockerd.git

$ wget https://storage.googleapis.com/golang/getgo/installer_linux
$ chmod +x ./installer_linux
$ ./installer_linux
$ source ~/.bash_profile

$ cd cri-dockerd
$ mkdir bin
$ go build -o bin/cri-dockerd
$ mkdir -p /usr/local/bin
$ sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
$ sudo cp -a packaging/systemd/* /etc/systemd/system
$ sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
$ sudo systemctl daemon-reload
$ sudo systemctl enable cri-docker.service
$ sudo systemctl enable --now cri-docker.socket
$ sudo systemctl status cri-docker.socket

$ sudo kubeadm config images pull --cri-socket=unix:///run/cri-dockerd.sock
$ sudo kubeadm init \
  --service-cidr=10.99.0.0/16 \
  --pod-network-cidr=10.200.0.0/16 \
  --cri-socket=unix:///run/cri-dockerd.sock \
  --upload-certs \
  --control-plane-endpoint=kubernetes.local
```

added kubernetes.local
```
$ sudo vi /etc/hosts
```

Kurulum düzgün bir şekilde tamamlandığında worker ve master node olabilmesi için makinenin gerekli token bilgisi görüntülenecektir.

worker node için aşağıdaki biçiminde kullanılması gereklidir. token yerine kurulum sonrası verilen token yazılacaktır. Ayrıca dikkat edilmesi gereken `--cri-socket=unix:///run/cri-dockerd.sock` parametresininde eklenmesi gerektiğidir.
```
$ sudo kubeadm join kubernetes.local:6443 --token xbq2kh.uza7zx6266lucthd \
	--discovery-token-ca-cert-hash sha256:<token> \
	--cri-socket=unix:///run/cri-dockerd.sock
```

Node sonradan eklenirse isim vermek için aşağıdaki komut kullanılabilir.
```
kubectl label nodes worker1 node-role.kubernetes.io/worker=worker
```

## 2.3.3. Installing CRI-O runtime for Docker
[CRI-O Installation Instructions](https://github.com/cri-o/cri-o/blob/main/install.md#installation-instructions)
```
-----
$ sudo -i
# OS="xUbuntu_22.04"
# VERSION=1.24

# echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

# echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

# mkdir -p /usr/share/keyrings

# curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg

# curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

# apt-get update
# apt-get install -y cri-o cri-o-runc
# exit

$ sudo systemctl daemon-reload
$ sudo systemctl restart crio
$ sudo systemctl enable crio
$ systemctl status crio
```

## 2.4. Setting up containerd for Kubernetes
[Setting up containerd for Kubernetes](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#setting-up-containerd-for-kubernetes)

```
$ sudo apt-get update
$ sudo apt-get upgrade -y
$ sudo apt-get install containerd -y
$ sudo mkdir -p /etc/containerd
$ sudo containerd config default | sudo tee /etc/containerd/config.toml
$ cat /etc/containerd/config.toml
$ sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
$ cat /etc/containerd/config.toml
$ sudo systemctl restart containerd
$ sudo systemctl enable containerd
$ sudo systemctl status containerd
```

## 2.4.1 kubernetes cluster setup for containerd

init komutunun farklı çalışması 
`$ sudo kubeadm init --pod-network-cidr=192.168.10.0/24`
```
$ ip addr
$ sudo kubeadm init \
--apiserver-advertise-address=192.168.200.136 \
--control-plane-endpoint=192.168.200.136 \
--service-cidr=10.96.0.0/12 \
--pod-network-cidr=10.244.0.0/16
```
veya \
Benim tercihim
```
sudo kubeadm init \
  --service-cidr=10.99.0.0/16 \
  --pod-network-cidr=10.200.0.0/16 \
  --upload-certs \
  --control-plane-endpoint=kubernetes.local
```
**Yukarıdaki komut hata verirse çalıştırılması gereken komutlar aşağıdadır.**
```
$ sudo cp /etc/containerd/config.toml /etc/containerd/config-with-docker.toml
$ sudo rm /etc/containerd/config.toml
$ sudo containerd config default | sudo tee /etc/containerd/config.toml
$ sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
$ sudo systemctl restart containerd
```
**Komutlar sonrasında tekrar kubeadm init çalıştırılmalıdır.**
## 2.5. make sure the installation is working
```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

$ kubectl get componentstatuses
$ sudo systemctl status kubelet.service
$ kubectl get nodes
```
Aşağıdaki komutla kubernetes ile ilgili servislerin çalışıp çalışmadığı kontrol edilebilir.
```
$ sudo apt-get install net-tools
$ sudo netstat -lnpt | grep kube
$ sudo netstat -a | grep 6443
```
Kontrol amaçlı aşağıdaki komutlar denenebilir.
```
$ ip addr
$ telnet <ip> 6443
```
Eğer telnet bağlantısı başarısız olursa firewall etkinleştirilerek 6443 portuna izin verilir.
```
$ sudo ufw status verbose
$ sudo ufw disable
$ sudo ufw enable
$ sudo ufw allow 6443/tcp
$ telnet <ip> 6443
```

`sudo journalctl -xeu kubelet`

Eğer worker token unutuldu ise aşağıdaki komut ile worker join token görüntülenebilir.
```
kubeadm token create --print-join-command
```
## 2.6 Cluster Ready
[Deploying flannel manually](https://github.com/flannel-io/flannel#deploying-flannel-manually)
```
$ kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```
veya \
benim tercihim
```
$ wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```
cluster oluştururken --pod-network-cidr ip adresi ne girildi ise o değiştirilmelidir.
```
$ vi kube-flannel.yml
```
![kubernetes network](/img/kubernetes_p01.png)

```
$ kubectl apply -f kube-flannel.yml
$ kubectl get pods -n kube-flannel
$ kubectl get nodes -w
```
```
$ kubectl get pods -A
$ kubectl cluster-info
$ kubectl get nodes -o wide
```

[Install Calico](https://projectcalico.docs.tigera.io/getting-started/kubernetes/quickstart)

Master node üzerinde aşağıdaki kodlar çalıştırılır.
```
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml
```


<hr>

[Running kubeadm without an Internet connection](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#without-internet-connection)
[What is cgroup v2](https://kubernetes.io/docs/concepts/architecture/cgroups/#cgroup-v2)\
[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime)
```
$ sudo kubeadm config images pull
$ sudo kubeadm config images pull --cri-socket="unix:///var/run/containerd/containerd.sock"
$ sudo kubeadm config images pull --cri-socket="unix:///var/run/docker.sock"
$ sudo kubeadm config images list
$ ip addr
$ sudo kubeadm init --pod-network-cidr=192.168.99.0/24 --apiserver-advertise-address=192.168.200.136 --control-plane-endpoint=192.168.200.136
```

```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
[Play with Kubernetes](https://labs.play-with-k8s.com/)
# 3. MINIKUBE INSTALATION
[minikube Instalation](https://minikube.sigs.k8s.io/docs/start/)
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
```
```
sudo dpkg -i minikube_latest_amd64.deb
```

[minikube manual pulling](https://console.cloud.google.com/gcr/images/k8s-minikube/global/kicbase)
```
docker pull gcr.io/k8s-minikube/kicbase:v0.0.36
```
```
docker pull gcr.io/k8s-minikube/kicbase@sha256:8debc1b6a335075c5f99bfbf131b4f5566f68c6500dc5991817832e55fcc9456
``` 
```
minikube start
```

Aşağıdaki seçenekle varsayılan değil istediğimiz driver kullanılarak kurulum yapılır. \
```
minikube start --driver=docker --container-runtime=containerd
```
## 3.1 minikube ERRORS AND FIXED
### 3.1.1. minikube unable download
![HATA](/img/docker_minikube_p01_error.png) \
Yukarıdaki gibi bir hata alınırsa docker pull işlemini manuel olarak yapabiliriz. Bunun için aşağıdaki komutlar kullanılabilir. \
[Google Cloud Container Registry](https://console.cloud.google.com/gcr/images/k8s-minikube/global/kicbase)
```
docker pull gcr.io/k8s-minikube/kicbase:v0.0.36
```
```
docker pull gcr.io/k8s-minikube/kicbase@sha256:8debc1b6a335075c5f99bfbf131b4f5566f68c6500dc5991817832e55fcc9456
```
### 3.1.2. cpu controller needs to be delegated
![HATA](/img/docker_minikube_p02_error.png) \
Yukarıdaki gibi bir hata alınırsa aşağıdaki komutlar uygulanır. \
[Enabling CPU, CPUSET, and I/O delegation
](https://rootlesscontaine.rs/getting-started/common/cgroup2/#enabling-cpu-cpuset-and-io-delegation) 

```
cat /sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/cgroup.controllers
```

```
sudo mkdir -p /etc/systemd/system/user@.service.d
```

```
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
```
```
sudo systemctl daemon-reload
```
```
kubectl get po -A
```
```
minikube kubectl -- get po -A
```
```
alias kubectl="minikube kubectl --"
```
```
minikube dashboard
```
<hr>

`minikube delete --all`\
`minikube delete --all --purge` -> minikube ile ilgili herşeyin sistemden kaldırılması\
`docker system prune --volumes`

## 3.2. [minikube bash auto-completion on Linux](https://minikube.sigs.k8s.io/docs/commands/completion/)
```
$ echo 'source <(minikube completion bash)' >>~/.bashrc
$ exec bash
```

## 3.3. minikube env host docker env olarak kullanılması
```
$ docker container ls
$ minikube docker-env
$ eval $(minikube docker-env)
$ docker container ls

```
## 3.4. minikube with kubectl
```
$ minikube start --driver=docker --container-runtime=containerd
$ minikube status
$ kubectl get nodes
```
![](/img/docker_kubernetes_p01.png)

| Command        | Description |
| -------------- | ----------- |
| `minikube stop` | minikube cluster yapısını silmeden durdurmak için kullanılır. `docker container ls` minikube container inin durdurulduğu görüntülenir. |
| `minikube delete` | minikube cluster yapısını siler. |
