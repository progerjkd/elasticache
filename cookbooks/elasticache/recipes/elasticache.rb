#
# Cookbook:: elasticache
# Recipe:: elasticache
#
# Copyright:: 2018, Roger Vasconcelos, All Rights Reserved.

memcached = aws_cache_cluster 'memcached' do
  az_mode 'single-az'
  engine  'memcached'
  engine_version '1.5.10'
  node_type 'cache.t2.micro'
  number_nodes 1
  security_groups ['cacheSG']
  subnet_group_name 'cacheSubnetGroup'
end

ruby_block 'create memcached data bag' do
  block do
    # checks if the 'aws_info' data bag exists
    begin
      data_bag('aws_info')
    rescue StandardError
      Chef::Log.warn('Databag aws_info not found! Creating it.')
      aws_info = Chef::DataBag.new
      aws_info.name('aws_info')
      aws_info.create
    end

    memcached = {
      'id' => 'memcached',
      'address' => memcached.aws_object.configuration_endpoint.address,
      'port' => memcached.aws_object.configuration_endpoint.port,
    }

    databag_item = Chef::DataBagItem.new
    databag_item.data_bag('aws_info')
    databag_item.raw_data = memcached
    databag_item.save
  end
end
