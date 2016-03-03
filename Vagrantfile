# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

n_nodes = 3

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.define "lb", primary: true do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "10.99.80.10", virtualbox__intnet: true
    lb.vm.network "forwarded_port", guest: 80, host: 8080
    lb.vm.network "forwarded_port", guest: 443, host: 8443
    lb.vm.provision "shell", inline: "/vagrant/files/provision-lb.sh #{n_nodes}"
  end

  (1..n_nodes).each do |i|
    config.vm.define "web#{i}" do |node|
      node.vm.hostname = "web#{i}"
      node.vm.network "private_network", ip: "10.99.80.#{i+10}", virtualbox__intnet: true
      node.vm.provision "shell", inline: "/vagrant/files/provision-node.sh #{i}"
    end
  end
end
