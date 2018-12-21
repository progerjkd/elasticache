#
# Cookbook:: elasticache
# Recipe:: webserver
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'httpd'
package 'php'
package 'php-pecl-memcache'

service 'httpd' do
  action [ :enable, :start ]
end

# configuration of memcached as php session handler
template '/etc/php.d/memcache.ini' do
  source 'memcache.ini.erb'
  variables lazy {
    {
      mem_host:  node.run_state['memcached'],
      mem_port:  node.run_state['memcached_port']
    }
  }
  notifies :restart, 'service[httpd]', :delayed
end

# phpmemcachedadmin install
src_filename = '1.3.0.tar.gz'
src_url="https://github.com/elijaa/phpmemcachedadmin/archive/#{src_filename}"
src_filepath = '/tmp'
extract_path = '/var/www/html/phpmemcachedadmin'

remote_file "#{src_filepath}/#{src_filename}" do
  source "#{src_url}"
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

directory '/var/www/html/phpmemcachedadmin/Temp/' do
  group 'apache'
end

template '/var/www/html/phpmemcachedadmin/Config/Memcache.php' do
  source "Memcache.php.erb"
  variables lazy {
    {
      mem_host:  node.run_state['memcached'],
      mem_port:  node.run_state['memcached_port']
    }
  }
  not_if { ::File.exist?('/var/www/html/phpmemcachedadmin/Config/Memcache.php') }
end
