yum update -y
yum install wget iptables vim bash-completion -y
wget https://github.com/rancher/rke2/releases/download/v1.24.2%2Brke2r1/rke2.linux-amd64.tar.gz
tar xvf rke2.linux-amd64.tar.gz
cp bin/* /usr/local/bin/
cp share/rke2/* /usr/local/share/
cp lib/systemd/system/rke2-server.service /usr/lib/systemd/system/
mkdir -p /etc/rancher/rke2/
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 9345 -j ACCEPT
touch /etc/rancher/rke2/config.yaml
cat <<EOF > /etc/rancher/rke2/config.yaml
token: "9psrbtzzcttcrc2thzgmb5lfmgnpv2vgqpp8rdpjrzzqpd22mpv5rm"
server: https://ec2-44-195-87-125.compute-1.amazonaws.com:9345
cni: "cilium"
disable-etcd: true
disable-kube-proxy: false
node-taint: [
  "node-role.kubernetes.io/control-plane:NoSchedule"
]
disable: rke2-ingress-nginx
EOF
sed -i '/nm-cloud-setup.service/d' /usr/lib/systemd/system/rke2-server.service 

mkdir ~/.kube
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
cp ./kubectl /usr/local/bin/
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc

#cp  /etc/rancher/rke2/rke2.yaml ~/.kube/config
