#
# Cookbook:: elasticache
# Recipe:: instance
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

machine 'node01' do
  machine_options(
    bootstrap_options: {
      subnet_id: 'cacheSubnet',
      security_group_ids: ['cacheSG'],
      image_id: 'ami-009d6802948d06e52',
      instance_type: 't2.micro',
      associate_public_ip_address: true
    },
    aws_tags: {:myTAG => node.run_state['memcached']},
    transport_address_location: :public_ip,
    ssh_username: 'ec2-user',
    sudo: true
  )
  recipe 'elasticache::webserver'
#  run_list [ 'elasticache::webserver' ]
end
