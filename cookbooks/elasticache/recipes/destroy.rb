#
# Cookbook:: elasticache
# Recipe:: destroy
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#
# Cookbook:: elasticache_memcached
# Recipe:: destroy
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

machine 'node01' do
  action :destroy
end

aws_cache_cluster 'memcached' do
  action :destroy
end

aws_cache_subnet_group 'cacheSubnetGroup' do
  action :destroy
end

aws_security_group 'cacheSG' do
  action :destroy
end

aws_subnet 'cacheSubnet' do
  action :destroy
end

aws_vpc 'cacheVPC' do
  action :destroy
end
