# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
Vagrant.configure(2) do |config| 
 config.vm.box = "centos/7" 
 config.vm.box_version = "2004.01" 
 config.vm.provider "virtualbox" do |v| 
 v.memory = 512 
 v.cpus = 2 
 config.vbguest.auto_update = false
 end 
 config.vm.define "repo" do |repo| 
    repo.vm.box_check_update = false
    repo.vm.network "private_network", ip: "192.168.50.10",  virtualbox__intnet: "net1" 
    repo.vm.hostname = "repo" 
    repo.vm.provision "file", source: "./repo", destination: "./repo_build"
    repo.vm.provision "file", source: "./compose", destination: "./repo_compose"
    repo.vm.provision "file", source: "./nginx_new.spec", destination: "./for_build/nginx_new.spec"
    repo.vm.provision "shell", path: "install.sh"
 end 
 config.vm.define "repoDownload" do |repoDownload| 
    repoDownload.vm.box_check_update = false
    repoDownload.vm.network "private_network", ip: "192.168.50.11",  virtualbox__intnet: "net1" 
    repoDownload.vm.hostname = "repoDownload" 
    repoDownload.vm.provision "shell", path: "download.sh"
 end 
end 

