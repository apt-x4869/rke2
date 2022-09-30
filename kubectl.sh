cp  /etc/rancher/rke2/rke2.yaml ~/.kube/config
k label nodes ip-172-31-12-178.ec2.internal node-role.kubernetes.io/worker=true
k create ns httpd
k create deployment nginx --image nginx --replicas 2
k create deployment httpd --image httpd --replicas 2 -n httpd
k expose deployment nginx --port 8080
k expose deployment httpd --port 8080 -n httpd

copy ssh-keygen authorized-key

mkdir /backup
rke2-killall.sh

scp -r /var/lib/rancher/rke2/server/cred 172.31.5.18:/backup/var-lib-rancher-rke2-server-cred
scp -r /var/lib/rancher/rke2/server/tls 172.31.5.18:/backup/var-lib-rancher-rke2-server-tls
scp -r /var/lib/rancher/rke2/server/token 172.31.5.18:/backup/var-lib-rancher-rke2-server-token
scp -r /etc/rancher/ 172.31.5.18:/backup/etc-rancher
scp -r /var/lib/rancher/rke2/server/db/snapshots/pre-upgrade-snapshot-ip-172-31-0-222.ec2.internal-1664346826 172.31.5.18:/backup/snapshot
scp -r /var/lib/rancher/rke2/server/db/etcd/member/snap/db 172.31.5.18:/backup/db


rm -rf /etc/rancher/
cp /backup/etc-rancher/ /etc/rancher -r
mkdir -p /var/lib/rancher/rke2/server/
cp -r /backup/var-lib-rancher-rke2-server-cred/ /var/lib/rancher/rke2/server/cred
cp -r /backup/var-lib-rancher-rke2-server-tls/ /var/lib/rancher/rke2/server/tls
cp /backup/var-lib-rancher-rke2-server-token /var/lib/rancher/rke2/server/token
