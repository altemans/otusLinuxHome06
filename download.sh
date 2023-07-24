yum update
yum install curl

cat >> /etc/yum.repos.d/network.repo << EOF
[network]
name=network-universal
baseurl=http://repo:8080/repo/el/x86_64/centos/7
gpgcheck=0
enabled=1
EOF
echo 192.168.50.10 repo >> /etc/hosts

yum --disablerepo=* --enablerepo=network-universal
yum update

while [ curl -o /dev/null -s -w "%{http_code}\n" http://repo:8080/repo/el/x86_64/centos/7/nginx-1.20.2-1.el7.ngx.x86_64.rpm != 200 ]
do
    sleep 1s
done

yum install -y nginx