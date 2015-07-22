# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'vagrant_ros_guest_plugin.rb'

$rsync_folder_disabled = true
$expose_rancher_ui = 8080
$vb_gui = false
$vb_memory = 1024
$vb_cpus = 1
$private_ip = "172.17.8.100"

Vagrant.configure(2) do |config|
  config.vm.box         = "rancherio/rancheros"
  config.vm.box_version = ">=0.3.3"

  hostname = "rancher"

  config.vm.define hostname do |node|
    node.vm.network "forwarded_port", guest: 8080, host: $expose_rancher_ui, auto_correct: true

    node.vm.provider "virtualbox" do |vb|
      vb.gui = $vb_gui
      vb.memory = $vb_memory
      vb.cpus = $vb_cpus
    end

    node.vm.network "private_network", ip: $private_ip

    node.vm.provision :shell, :inline => "docker run -d -p 8080:8080 rancher/server:latest", :privileged => true
    node.vm.provision :shell, :inline => "docker run -e CATTLE_AGENT_IP=%s -e WAIT=true -v /var/run/docker.sock:/var/run/docker.sock rancher/agent:latest http://localhost:8080" % $private_ip, :privileged => true

    # Disabling compression because OS X has an ancient version of rsync installed.
    # Add -z or remove rsync__args below if you have a newer version of rsync on your machine.
    node.vm.synced_folder ".", "/opt/rancher", type: "rsync",
        rsync__exclude: ".git/", rsync__args: ["--verbose", "--archive", "--delete", "--copy-links"],
        disabled: $rsync_folder_disabled
  end
end
