#
# Cookbook:: elasticache
# Recipe:: elasticache
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

my_cache = aws_cache_cluster 'memcached' do
  az_mode 'single-az'
  engine  'memcached'
  engine_version  '1.5.10'
  node_type 'cache.t2.micro'
  number_nodes 1
  security_groups ['cacheSG']
  subnet_group_name 'cacheSubnetGroup'
end

node.run_state['memcached'] = 'blah'
#my_cache.aws_object.configuration_endpoint.address
node.run_state['memcached_port'] = 'blu'
#my_cache.aws_object.configuration_endpoint.port
