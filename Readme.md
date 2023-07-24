# Home 06 repo

<details>
  <summary>home 06</summary>

### Размещаем свой RPM в своем репозитории

У меня имеются проблемы с dyn-dns, пробросить порт не получится, поэтому репу буду поднимать в первой тачке, а со второй буду подключаться и устанавливать измененный пакет

для автоматизации все затолкал в два скрипта, первый на тачке repo собирает пакет, собирает в докере репу и размещает собранный пакет в репе, второй на тачке repoDownload отключает все репы, подключает новую, внутреннюю, под названием network и устанавливает из нее пересобранный пакет nginx


</details>

# скрипты

<details>
  <summary>скрипт 1 install.sh</summary>
  

```
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

```

</details>


<details>
  <summary>скрипт 2 download.sh</summary>
  

```
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

```

</details>


<details>
  <summary>результат на второй тачке</summary>
  

```
   repoDownload: Is this ok [y/d/N]: Exiting on user command
    repoDownload: Your transaction was saved, rerun it with:
    repoDownload:  yum load-transaction /tmp/yum_save_tx.2023-07-24.11-38.D0ZCGh.yumtx
    repoDownload: /tmp/vagrant-shell: line 16: [: too many arguments
    repoDownload: Loaded plugins: fastestmirror
    repoDownload: Loading mirror speeds from cached hostfile
    repoDownload:  * base: mirror.hostnet.nl
    repoDownload:  * extras: centos.mirror.liteserver.nl
    repoDownload:  * updates: mirror.wd6.net
    repoDownload: Resolving Dependencies
    repoDownload: --> Running transaction check
    repoDownload: ---> Package nginx.x86_64 1:1.20.2-1.el7.ngx will be installed
    repoDownload: --> Finished Dependency Resolution
    repoDownload: 
    repoDownload: Dependencies Resolved
    repoDownload: 
    repoDownload: ================================================================================
    repoDownload:  Package       Arch           Version                     Repository       Size
    repoDownload: ================================================================================
    repoDownload: Installing:
    repoDownload:  nginx         x86_64         1:1.20.2-1.el7.ngx          network         2.1 M
    repoDownload: 
    repoDownload: Transaction Summary
    repoDownload: ================================================================================
    repoDownload: Install  1 Package
    repoDownload: 
    repoDownload: Total download size: 2.1 M
    repoDownload: Installed size: 6.0 M
    repoDownload: Downloading packages:
    repoDownload: Running transaction check
    repoDownload: Running transaction test
    repoDownload: Transaction test succeeded
    repoDownload: Running transaction
    repoDownload:   Installing : 1:nginx-1.20.2-1.el7.ngx.x86_64                              1/1
    repoDownload: ----------------------------------------------------------------------
    repoDownload: 
    repoDownload: Thanks for using nginx!
    repoDownload: 
    repoDownload: Please find the official documentation for nginx here:
    repoDownload: * https://nginx.org/en/docs/
    repoDownload: 
    repoDownload: Please subscribe to nginx-announce mailing list to get
    repoDownload: the most important news about nginx:
    repoDownload: * https://nginx.org/en/support.html
    repoDownload: 
    repoDownload: Commercial subscriptions for nginx are available on:
    repoDownload: * https://nginx.com/products/
    repoDownload: 
    repoDownload: ----------------------------------------------------------------------
    repoDownload:   Verifying  : 1:nginx-1.20.2-1.el7.ngx.x86_64                              1/1
    repoDownload: 
    repoDownload: Installed:
    repoDownload:   nginx.x86_64 1:1.20.2-1.el7.ngx
    repoDownload: 
    repoDownload: Complete!

```

</details>