#
# Cookbook:: elasticache
# Recipe:: instance
#
# Copyright:: 2018, Roger Vasconcelos, All Rights Reserved.

node01 = machine 'node01' do
  machine_options(
    bootstrap_options: {
      subnet_id: 'cacheSubnet',
      security_group_ids: ['cacheSG'],
      image_id: 'ami-009d6802948d06e52',
      instance_type: 't2.micro',
      associate_public_ip_address: true,
    },
    transport_address_location: :public_ip,
    ssh_username: 'ec2-user',
    sudo: true
  )
  run_list [ 'elasticache::webserver' ]
end
