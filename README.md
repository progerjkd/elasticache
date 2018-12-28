

# ElastiCache Cookbook
This is a simple cookbook to provision an ElastiCache memcached cluster.
The following recipes are included:

 - **elasticache::networking**: Provisions all the infrastructure needed to deploy a VPC isolated ElastiCache instance - VPC, Subnet, Security Group and ElastiCache Subnet Group.
 - **elasticache::elasticache**: Creates the memcached instance.
 - **elasticache::instance**: Provisions an ec2 instance via Chef Provisioning, using the [AWS Driver](https://docs.chef.io/provisioning_aws.html).
 - **elasticache::webserver**: Configure an Apache + PHP node, sets up the memcached instance as PHP session handler, and installs phpmycachedadmin monitoring tool.
 
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

**To apply the cookbook, you must run it through chef-client in local-mode:**

    chef-client --listen -z -r 'recipe[elasticache]'

The `elasticache::default` calls the remaining recepies in the following order:

    include_recipe 'elasticache::networking'
    include_recipe 'elasticache::elasticache'
    include_recipe 'elasticache::instance'

Despite required, a test kitchen run of this cookbook is [not the most appropriade way of using chef-provisioning](https://stackoverflow.com/questions/44919724/unable-to-load-provisioning-aws-driver-when-running-chef-test-kitchen). Nevertheless, a configured `.kitchen.yml` file is providen with an encrypted data bag.

To clean up the provisioned AWS resources call:

    chef-client --listen -z -r 'recipe[elasticache::destroy]'

During the local-run of chef-zero server, I could not retrieve the endpoint address of the ElastiCache instance to use in the template files for PHP and phpmemcachedadmin. I think if this cookbook was run in a chef-server these values could be retrieved.



