yum update
yum install -y redhat-lsb-core wget rpmdevtools rpm-build yum-utils gcc

wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm
rpm -i nginx-1.*
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.tar.gz
tar -xvf OpenSSL_1_1_1-stable.tar.gz
cp -R openssl-OpenSSL_1_1_1-stable /root/openssl-OpenSSL_1_1_1-stable
cp -f for_build/nginx_new.spec /root/rpmbuild/SPECS/nginx.spec
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
ll /root/rpmbuild/RPMS/x86_64/


yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
cd repo_build
docker build -t repo:test .
cd ..
mkdir -p /repo/{repo,repo-load}
chmod 777 -R /repo
docker compose -f repo_compose/docker-compose.yml up -d
cp /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el7.ngx.x86_64.rpm /repo/repo-load/