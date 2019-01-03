#
# Cookbook:: elasticache
# Recipe:: webserver
#
# Copyright:: 2018, Roger Vasconcelos, All Rights Reserved.

package 'httpd'
package 'php'
package 'php-pecl-memcache'

service 'httpd' do
  action [ :enable, :start ]
end

memcached_db = data_bag_item('aws_info', 'memcached')

# configuration of memcached as php session handler
template '/etc/php.d/memcache.ini' do
  source 'memcache.ini.erb'
  variables lazy {
    {
      memcached_host:  memcached_db['address'],
      memcached_port:  memcached_db['port'],
    }
  }
  notifies :restart, 'service[httpd]', :delayed
end

# phpmemcachedadmin install
src_filename = '1.3.0.tar.gz'
src_url = "https://github.com/elijaa/phpmemcachedadmin/archive/#{src_filename}"
src_filepath = '/tmp'
extract_path = '/var/www/html/phpmemcachedadmin'

remote_file "#{src_filepath}/#{src_filename}" do
  source src_url
  not_if { ::File.exist?("#{src_filepath}/#{src_filename}") }
end

bash 'extract_module' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar zxf #{src_filepath}/#{src_filename} -C #{extract_path} --strip-components=1
  EOH
  not_if { ::File.exist?(extract_path) }
end

%w( /var/www/html/phpmemcachedadmin/Temp/ /var/www/html/phpmemcachedadmin/Config/ ).each do |path|
  directory path do
    group 'apache'
    mode  '0775'
  end
end

template '/var/www/html/phpmemcachedadmin/Config/Memcache.php' do
  source  'Memcache.php.erb'
  group   'apache'
  mode    '0660'
  variables lazy {
    {
      memcached_host:  memcached_db['address'],
      memcached_port:  memcached_db['port'],
    }
  }
end
puts "\e[1m\e[92m\e[5m=>\e[25m Configuration done. \e[5m<=\e[0m"
puts "Access PHPMemcachedAdmin via URL: \e[1m\e[35mhttp://#{node['ec2']['public_hostname']}/phpmemcachedadmin\e[0m"
