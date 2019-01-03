#
# Cookbook:: elasticache
# Recipe:: destroy
#
# Copyright:: 2018, Roger Vasconcelos, All Rights Reserved.

require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

aws_cache_cluster 'memcached' do
  action :destroy
end

# cache_instance = nil

ruby_block 'wait for memcached instance to terminate' do
  block do
    print "\nWaiting for ElastiCache instance be deleted"
    exit_var = 0
    while exit_var == 0

      begin
        Chef::Resource::AwsCacheCluster.get_aws_object(
          'memcached',
          run_context: run_context,
          driver: run_context.chef_provisioning.current_driver,
          managed_entry_store: ::Chef::Provisioning.chef_managed_entry_store(run_context.cheffish.current_chef_server)
        )
        print '.'
        sleep(5)
      rescue
        exit_var = 1
      end

    end
  end
end

machine 'node01' do
  action :destroy
end

aws_subnet 'cacheSubnet' do
  action :purge
end

aws_security_group 'cacheSG' do
  action :purge
end

aws_cache_subnet_group 'cacheSubnetGroup' do
  action :purge
end

aws_vpc 'cacheVPC' do
  action :purge
end
