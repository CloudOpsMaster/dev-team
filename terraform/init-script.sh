#!/bin/bash

# Оновлення системи
sudo apt-get update && sudo apt-get upgrade -y

# Встановлення Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Ініціалізація Kubernetes
kubeadm init --apiserver-advertise-address 10.0.0.4 --pod-network-cidr 10.24.0.0/16

# Додати ноди до кластера
mkdir -p ~/.kube