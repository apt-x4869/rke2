yum update -y
yum install wget iptables vim bash-completion  -y
wget https://github.com/rancher/rke2/releases/download/v1.24.2%2Brke2r1/rke2.linux-amd64.tar.gz
tar xvf rke2.linux-amd64.tar.gz
cp bin/* /usr/local/bin/
cp share/rke2/* /usr/local/share/
cp lib/systemd/system/rke2-server.service /usr/lib/systemd/system/
mkdir -p /etc/rancher/rke2/
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 9345 -j ACCEPT
touch /etc/rancher/rke2/config.yaml
cat <<EOF > /etc/rancher/rke2/config.yaml
disable-apiserver: true
cni: "cilium"
disable-controller-manager: true
disable-kube-proxy: false
disable-scheduler: true
node-taint: [
  "node-role.kubernetes.io/etcd:NoExecute"
]
token: "9psrbtzzcttcrc2thzgmb5lfmgnpv2vgqpp8rdpjrzzqpd22mpv5rm"
disable: rke2-ingress-nginx
EOF
sed -i '/nm-cloud-setup.service/d' /usr/lib/systemd/system/rke2-server.service
