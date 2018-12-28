#
# Cookbook:: elasticache
# Recipe:: networking
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_vpc 'cacheVPC' do
  cidr_block '172.16.0.0/16'
  main_routes '0.0.0.0/0' => :internet_gateway
  internet_gateway true
  enable_dns_hostnames true
  enable_dns_support true
end

aws_subnet 'cacheSubnet' do
  vpc 'cacheVPC'
  cidr_block '172.16.1.0/24'
end

aws_security_group 'cacheSG' do
  vpc 'cacheVPC'
  description 'Security Group for elasticache testing'
  inbound_rules [
    {:port => 22, :protocol => :tcp, :sources => ['0.0.0.0/0'] },
    {:port => 80, :protocol => :tcp, :sources => ['0.0.0.0/0'] },
    {:port => 11211, :protocol => :tcp, :sources => ['cacheSG'] }
  ]
end

aws_cache_subnet_group 'cacheSubnetGroup' do
  subnets [ 'cacheSubnet' ]
  description 'Subnet for elasticache testing'
end
