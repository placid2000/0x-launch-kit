projectName = "relayer"
vagrantOS = "ubuntu/trusty64"
serverIp = "192.168.115.200"

Vagrant.configure(2) do |config|
    config.vm.box = vagrantOS
    config.vm.network "private_network", ip: serverIp
    if Vagrant::Util::Platform.windows? then
        puts "Vagrant launched from Windows."
        config.vm.synced_folder ".", "/vagrant", type: "nfs"
    else
        puts "Vagrant launched from mac."
        config.vm.synced_folder ".", "/vagrant", type: "nfs", :nfs => true, :mount_options => ['actimeo=2']
    end
    config.vm.provision :shell, path: "vagrant_config/bootstrap.sh"
    config.vm.provider "virtualbox" do |v|
       v.name = projectName
       v.memory = 2048
       v.cpus = 1
    end
end
