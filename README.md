
# elasticache cookbook
This is a simple cookbook to provision an ElastiCache memcached cluster.
The following recipes are included:

 - **elasticache::networking**: Provisions all the infrastructure needed to deploy a VPC isolated ElastiCache instance - VPC, Subnet, Security Group and ElastiCache Subnet Group.
 - **elasticache::elasticache**: Creates the memcached instance.
 - **elasticache::instance**: Provisions an ec2 instance via Chef Provisioning, using the [AWS Driver](https://docs.chef.io/provisioning_aws.html).
 - **elasticache::webserver**: Configure an Apache + PHP node, sets up the memcache instance as PHP session handler, and installs phpmycachedadmin monitoring tool.
 


# Running

**To apply the cookbook, you must run it through chef-client in local-mode:**

    chef-client --listen -z -r 'recipe[elasticache]'

The aws-cli must be configured to execute this cookbook properly.
The elasticache::default calls the remaining recepies in the following order:

    include_recipe 'elasticache::networking'
    include_recipe 'elasticache::elasticache'
    include_recipe 'elasticache::instance'

Despite required, a test kitchen run of this cookbook is [not the most appropriade way of using chef-provisioning](https://stackoverflow.com/questions/44919724/unable-to-load-provisioning-aws-driver-when-running-chef-test-kitchen).

To clean up the provisioned resources call:

    chef-client --listen -z -r 'recipe[elasticache::destroy]'

During the local-run of chef-zero server, I could not retrieve the endpoint address of the ElastiCache instance to use in the template files for PHP and phpmemcachedadmin. I think if this cookbook was run in a chef-server these values could be retrieved.
