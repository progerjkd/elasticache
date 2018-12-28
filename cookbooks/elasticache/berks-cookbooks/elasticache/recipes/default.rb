#
# Cookbook:: elasticache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

include_recipe 'elasticache::networking'
include_recipe 'elasticache::elasticache'
include_recipe 'elasticache::instance'
