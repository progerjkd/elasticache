#
# Cookbook:: elasticache
# Recipe:: elasticache
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_cache_cluster 'memcached' do
  az_mode 'single-az'
  engine  'memcached'
  engine_version  '1.5.10'
  node_type 'cache.t2.micro'
  number_nodes 1
  security_groups ['cacheSG']
  subnet_group_name 'cacheSubnetGroup'
end

# node.run_state['memcached'] = memcached.aws_object.configuration_endpoint.address
# node.run_state['memcached_port'] = memcached.aws_object.configuration_endpoint.port
