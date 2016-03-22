# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end  
  config.vm.define "node1" do |machine|
    machine.vm.network "private_network", ip: "172.17.177.21"
    machine.vm.provision :ansible do |ansible|
      ansible.playbook       = "dev.yml"
      ansible.verbose        = true
      ansible.host_key_checking = false
      ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
      ansible.sudo = true
    end  
  end
end
