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

# template '/root/meu.Memcache.php' do
#   source 'Memcache.php.erb'
# end
#
# template '/root/meu.memcache.ini' do
#   source 'memcache.ini.erb'
# end
