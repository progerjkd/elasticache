name 'elasticache'

%w( amazon centos fedora redhat ).each do |os|
  supports os
end

maintainer 'Roger Vasconcelos'
maintainer_email 'progerjkd@gmail.com'
license 'GPL-3.0+'
description 'Installs/Configures elasticache'
long_description 'This is a simple cookbook to provision an ElastiCache memcached cluster'
version '0.2.2'
chef_version '>= 13.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/progerjkd/elasticache/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/progerjkd/elasticache'
