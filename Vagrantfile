Vagrant.configure("2") do |config|

    #override global variables to fit Vagrant setup
    ENV['ENVOY_NAME']||="envoy01"
    ENV['ENVOY_IP']||="192.168.2.250"
    ENV['ENVOY_GUEST_PORT']||="10000"
    ENV['ENVOY_HOST_PORT']||="10000"
    ENV['ENVOY_LOG_LEVEL']||="info"
    
    #global config
    config.vm.synced_folder ".", "/vagrant"
    config.vm.synced_folder ".", "/usr/local/bootstrap"
    config.vm.box = "allthingscloud/web-page-counter"

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
    end

    config.vm.define "envoy" do |envoy|
        envoy.vm.hostname = ENV['ENVOY_NAME']
        envoy.vm.network "private_network", ip: ENV['ENVOY_IP']
        envoy.vm.network "forwarded_port", guest: ENV['ENVOY_GUEST_PORT'], host: ENV['ENVOY_HOST_PORT']
        envoy.vm.provision :shell, path: "scripts/install_envoy.sh"
   end

end
