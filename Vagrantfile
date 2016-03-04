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
    lb.vm.provision :shell, inline: "apt-get install --yes puppet puppet-module-puppetlabs-stdlib"
    lb.vm.provision :puppet do |puppet|
      puppet.manifest_file = "lb.pp"
      puppet.synced_folder_type = "rsync"
      puppet.facter = { "nodes" => (11..n_nodes+10).to_a.join(",") }
      puppet.options = "--parser future"
    end
  end

  (1..n_nodes).each do |i|
    config.vm.define "web#{i}" do |node|
      node.vm.hostname = "web#{i}"
      node.vm.network "private_network", ip: "10.99.80.#{i+10}", virtualbox__intnet: true
      node.vm.provision :shell, inline: "apt-get install --yes puppet"
      node.vm.provision :puppet, manifest_file: "node.pp", facter: { "node" => "#{i}" }, synced_folder_type: "rsync"
    end
  end
end
