# [INSTALLATION](https://kubernetes.io/docs/tasks/tools/)

[Install using native package management](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)

`sudo apt-get update` 

`sudo apt-get install -y ca-certificates curl` 

`sudo apt-get install -y apt-transport-https` 

`sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg` 

`echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list`

`sudo apt-get update`

`sudo apt-get install -y kubectl`

`type _init_completion` -> bash-completion yüklü olup olmadığının kontrolü

`sudo apt-get install bash-completion` 

`echo 'source <(kubectl completion bash)' >>~/.bashrc`

otomatik tamamlama ile ilgili işlemler `/etc/bash_completion.d` dosyası içerisinde yapılmıştır.

`exec bash` komutu ile otomatik tamamlama etkinleştirilir.
