# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"

  # mount source code
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "libzbxpgsql/", "/usr/src/libzbxpgsql"

  # Forward port for phpPgAdmin
  config.vm.network "forwarded_port", guest: 80, host: 9000, auto_correct: true
  config.vm.network "forwarded_port", guest: 5432, host: 5432, auto_correct: true

  config.vm.provision "shell", path: "vagrant/setup_centos7.sh"
end
