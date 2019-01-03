# ElastiCache Cookbook
This is a simple cookbook to provision an ElastiCache memcached cluster.
The following recipes are included:

 - `elasticache::networking`: Provisions all the infrastructure needed to deploy a VPC isolated ElastiCache instance - VPC, Subnet, Security Group and ElastiCache Subnet Group.
 - `elasticache::elasticache`: Creates the memcached instance.
 - `elasticache::instance`: Provisions an ec2 instance via Chef Provisioning, using the [AWS Driver](https://docs.chef.io/provisioning_aws.html).
 - `elasticache::webserver`: Configure an Apache + PHP node, sets up the memcached instance as PHP session handler, and installs PHPMemcachedAdmin monitoring tool.
 ![enter image description here](https://raw.githubusercontent.com/progerjkd/elasticache/master/AWS%20Architecture.png)
## Requirements
 - `awcli` should be installed and configured with valid AWS credentials.
 - Tested with the following ChefDK version:

       $ chef --version
        Chef Development Kit Version: 3.5.13
        chef-client version: 14.7.17
        delivery version: master (6862f27aba89109a9630f0b6c6798efec56b4efe)
        berks version: 7.0.6
        kitchen version: 1.23.2
        inspec version: 3.0.52

# Running

**To apply the cookbook, you should run it through chef-client in local-mode:**

    $ chef-client --listen -z -r 'recipe[elasticache]'

The `elasticache::default` file calls the recepies in the following order:

    include_recipe 'elasticache::networking'
    include_recipe 'elasticache::elasticache'
    include_recipe 'elasticache::instance'

Despite required, a test kitchen run of this cookbook is [not the most appropriade way of using chef-provisioning](https://stackoverflow.com/questions/44919724/unable-to-load-provisioning-aws-driver-when-running-chef-test-kitchen). Nevertheless, a configured `.kitchen.yml` file is providen with an encrypted data bag.

To **clean up the provisioned AWS resources** call:

    $ chef-client --listen -z -r 'recipe[elasticache::destroy]'

The EC2 instance's public address will be displayed at the end of the process. You can access phpmemcachedadmin via the URL shown:

    [node01] Starting Chef Client, version 14.8.12
             resolving cookbooks for run list: ["elasticache::webserver"]
             Synchronizing Cookbooks:
               - elasticache (0.1.0)
             Installing Cookbook Gems:
             Compiling Cookbooks...
             => Configuration done. <=
             Access PHPMemcachedAdmin via URL: http://ec2-3-85-214-81.compute-1.amazonaws.com/phpmemcachedadmin

The provisioning and deleting of the ElastiCache memcached usually takes a long time (~6 min), please do not cancel the resource creating/deleting processes.
