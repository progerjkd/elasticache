#
# Cookbook:: elasticache
# Recipe:: aws-config
#
# Copyright:: 2018, Roger Vasconcelos, All Rights Reserved.

# This recipe was intented to be used with test kitchen to configure the provision node.
# I decided to use 'chef-client --local-mode' instead.
# I left this file here only for consulting purpose.

# Iterate through the data bag and create the credentials file

puts 'Creating the AWS credentials file'

directory '/home/ec2-user/.aws' do
  owner 'ec2-user'
  group 'ec2-user'
end

directory '/root/.aws' do
  owner 'root'
  group 'root'
end

# Load the encrypted data bag into a hash
aws_credentials = Chef::EncryptedDataBagItem.load('aws', 'credentials').to_hash

# Iterate through the items, skip the "id"
aws_credentials.each_pair do |key, value|
  # skip the "id"
  next if key == 'id'

  template '/home/ec2-user/.aws/config' do
    source 'config.erb'
    owner 'ec2-user'
    group 'ec2-user'
    mode '0600'
    variables lazy {
      {
        profile:  key,
        region:   value['region'],
      }
    }
  end

  template '/root/.aws/config' do
    source 'config.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables lazy {
      {
        profile:  key,
        region:   value['region'],
      }
    }
  end

  template '/home/ec2-user/.aws/credentials' do
    source 'credentials.erb'
    owner 'ec2-user'
    group 'ec2-user'
    mode '0600'
    variables lazy {
      {
        profile:  key,
        access_key_id:      value['aws_access_key_id'],
        secret_access_key:  value['aws_secret_access_key'],
      }
    }
  end

  template '/root/.aws/credentials' do
    source 'credentials.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables lazy {
      {
        profile:  key,
        access_key_id:      value['aws_access_key_id'],
        secret_access_key:  value['aws_secret_access_key'],
      }
    }
  end
end
