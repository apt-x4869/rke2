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













    1  exit
    2  yum update -y
    3  yum install wget iptables vim bash-completion  -y
    4  wget https://github.com/rancher/rke2/releases/download/v1.24.2%2Brke2r1/rke2.linux-amd64.tar.gz
    5  tar xvf rke2.linux-amd64.tar.gz
    6  cp bin/* /usr/local/bin/
    7  cp share/rke2/* /usr/local/share/
    8  cp lib/systemd/system/rke2-server.service /usr/lib/systemd/system/
    9  mkdir -p /etc/rancher/rke2/
   10  iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 9345 -j ACCEPT
   11  touch /etc/rancher/rke2/config.yaml
   12  cat <<EOF > /etc/rancher/rke2/config.yaml
   13  disable-apiserver: true
   14  cni: "cilium"
   15  disable-controller-manager: true
   16  disable-kube-proxy: false
   17  disable-scheduler: true
   18  node-taint: [
   19    "node-role.kubernetes.io/etcd:NoExecute"
   20  ]
   21  token: "9psrbtzzcttcrc2thzgmb5lfmgnpv2vgqpp8rdpjrzzqpd22mpv5rm"
   22  disable: rke2-ingress-nginx
   23  EOF
   24  sed -i '/nm-cloud-setup.service/d' /usr/lib/systemd/system/rke2-server.service
   25  vim .ssh/authorized_keys
   26  mkdir /backup
   27  ls /backup
   28  rm -rf /etc/rancher/
   29  cp /backup/etc-rancher/ /etc/rancher -r
   30  mkdir -p /var/lib/rancher/rke2/server/
   31  ls /etc/rancher/
   32  cd /etc/rancher/node/password
   33  cat /etc/rancher/node/password
   34  cp -r /backup/var-lib-rancher-rke2-server-cred/ /var/lib/rancher/rke2/server/cred
   35  cp -r /backup/var-lib-rancher-rke2-server-tls/ /var/lib/rancher/rke2/server/tls
   36  cp /backup/var-lib-rancher-rke2-server-token /var/lib/rancher/rke2/server/token
   37  etcd
   38  vim /etc/rancher/rke2/config.yaml
   39  rke2 server --config /etc/rancher/rke2/config.yaml &
   40  export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
   41  etcdcontainer=$(/var/lib/rancher/rke2/bin/crictl ps --label io.kubernetes.container.name=etcd --quiet)
   42  /var/lib/rancher/rke2/bin/crictl exec $etcdcontainer sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl endpoint status --cluster --write-out=table"
   43  systemctl share/
   44  fg
   45  rm -rf /var/lib/rancher/
   46  rke2-killall.sh
   47  journalctl -u rke2-server -f
   48  ls /backup/
   49  ls /etc/rancher/
   50  rm -rf /etc/rancher/
   51  cp /backup/etc-rancher/ /etc/rancher -r
   52  mkdir -p /var/lib/rancher/rke2/server/
   53  cp -r /backup/var-lib-rancher-rke2-server-cred/ /var/lib/rancher/rke2/server/cred
   54  cp -r /backup/var-lib-rancher-rke2-server-tls/ /var/lib/rancher/rke2/server/tls
   55  cp /backup/var-lib-rancher-rke2-server-token /var/lib/rancher/rke2/server/token
   56  mkdir -p /var/lib/rancher/rke2/server/db/etcd/member/snap/
   57  cp /backup/db /var/lib/rancher/rke2/server/db/etcd/member/snap/db
   58  systemctl start rke2-server
   59  journalctl -u rke2-server -f
   60  export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
   61  etcdcontainer=$(/var/lib/rancher/rke2/bin/crictl ps --label io.kubernetes.container.name=etcd --quiet)
   62  /var/lib/rancher/rke2/bin/crictl exec $etcdcontainer sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl endpoint status --cluster --write-out=table"
   63  ls /var/lib/rancher/rke2/server/db/
   64  ls /var/lib/rancher/rke2/server/db/etcd/
   65  ls /var/lib/rancher/rke2/server/db/etcd/member/
   66  ls /var/lib/rancher/rke2/server/db/etcd/member/snap/
   67  ls /var/lib/rancher/rke2/server/db/etcd/member/snap/db -lrt
   68  date
   69  /var/lib/rancher/rke2/bin/crictl exec $etcdcontainer sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl member list --cluster --write-out=table"
   70  /var/lib/rancher/rke2/bin/crictl exec $etcdcontainer sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl member list"
   71  systemctl stop rke2-server
   72  rke2-killall.sh
   73  ls
   74  rm -rf /etc/rancher/
   75  rm -rf /var/lib/rancher/
   76  etcd
   77  yum install etcd
   78  ETCD_VER=v3.5.5
   79  # choose either URL
   80  GOOGLE_URL=https://storage.googleapis.com/etcd
   81  GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
   82  DOWNLOAD_URL=${GOOGLE_URL}
   83  rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
   84  rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test
   85  curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
   86  tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
   87  rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
   88  /tmp/etcd-download-test/etcd --version
   89  /tmp/etcd-download-test/etcdctl version
   90  yum install docker-ce docker
   91  yum install docker
   92  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
   93  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcdctl endpoint health"
   94  docker ps
   95  docker ps -a
   96  docker logs fd3e
   97  mkdir /etcd-data
   98  mkdir /tmp/etcd-data.tmp
   99  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  100  docker rm s1
  101  docker ps
  102  docker ps -a
  103  docker rm fd3e
  104  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  105  chmod 777 /etcd-data/
  106  chmod /tmp/etcd-data.tmp/
  107  chmod 777 /tmp/etcd-data.tmp/
  108  docker rm fd3e
  109  doocker ps
  110  docker ps
  111  docker ps -a
  112  docker rm 9a
  113  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  114  docker rm -a
  115  exit
  116  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  117  docker ps
  118  docker ps -a
  119  docker start 24
  120  docker ps
  121  docker exec etcd-gcr-v3.4.21 /bin/sh -c "/usr/local/bin/etcdctl version"
  122  docker exec etcd-gcr-v3.4.21 /bin/sh -c "ls /etcd-data"
  123  docker exec 24737 /bin/sh -c "ls /etcd-data"
  124  docker exec 24737 /bin/sh -c "ls /etcd-data/member"
  125  docker exec 24737 /bin/sh -c "ls /etcd-data/member/snap"
  126  docker stop 24
  127  clear
  128  docker rm -a
  129  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  130  mkdir /etcd-data
  131  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/etcd-data,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  132  docker rm a
  133  docker rm -a
  134  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/etcd-data,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  135  ls -lsr /
  136  cd /etcd-data/
  137  ls
  138  cd ..
  139  cd
  140  docker ps
  141  docker ps -a
  142  docker rm -a
  143  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/etcd-data,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  144  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/etcd-data,destination=/etcd-data   --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr --priviledged
  145  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/etcd-data,destination=/etcd-data  --priviledged  --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  146  docker rm -a
  147  podman run --help
  148  rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp &&   docker rmi gcr.io/etcd-development/etcd:v3.5.5 || true &&   docker run   -p 2379:2379   -p 2380:2380   --mount type=bind,source=/etcd-data,destination=/etcd-data --privileged --name etcd-gcr-v3.5.5   gcr.io/etcd-development/etcd:v3.5.5   /usr/local/bin/etcd   --name s1   --data-dir /etcd-data   --listen-client-urls http://0.0.0.0:2379   --advertise-client-urls http://0.0.0.0:2379   --listen-peer-urls http://0.0.0.0:2380   --initial-advertise-peer-urls http://0.0.0.0:2380   --initial-cluster s1=http://0.0.0.0:2380   --initial-cluster-token tkn   --initial-cluster-state new   --log-level info   --logger zap   --log-outputs stderr
  149  docker ps -a
  150  ls /etcd-data/
  151  ls /etcd-data/member/snap/db
  152  rm /etcd-data/member/snap/db
  153  cp /backup/db /etcd-data/member/snap/db
  154  docker ps -a
  155  docker start e22
  156  docker ps -a
  157  docker logs e22 -f
  158  docker logs -f e22
  159  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcd --version"
  160  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcdctl --version"
  161  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcdctl version"
  162  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcdctl endpoint health"
  163  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcdctl endpoint status"
  164  docker exec etcd-gcr-v3.5.5 /bin/sh -c "/usr/local/bin/etcdctl snapshot save /etcd-data/snapshot.db"
  165  ls /etcd-data/snapshot.db
  166  cp /etcd-data/snapshot.db /backup/snapshot-1
  167  docker rm -af
  168  rke2 server --cluster-reset --cluster-reset-restore-path /backup/snapshot-1
  169  rke2 server --cluster-reset --cluster-reset-restore-path /backup/snapshot-1 --token=9psrbtzzcttcrc2thzgmb5lfmgnpv2vgqpp8rdpjrzzqpd22mpv5rm
  170  systemctl start rke2-server
  171  journalctl -u rke2-server.service -f
  172  history