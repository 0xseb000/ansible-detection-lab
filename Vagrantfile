Vagrant.configure("2") do |config|

    machines = {
        "target" => "10.168.155.10",
        "observability" => "10.168.155.20"
    }

    machines.each do |name, ip|
        config.vm.define name do |node|
            node.vm.box = "bento/ubuntu-24.04"
            node.vm.network "private_network", ip: ip
        end
    end

    # Run the ansible playbook on the created vagrant vm (run with --no-provision until ansible is configured)
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook/site.yml"
        ansible.inventory_path = "inventory/hosts.yml"
        ansible.galaxy_role_file="requirements.yml"
    end

end