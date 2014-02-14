#!/usr/bin/env ruby

require 'aws-sdk'
require 'nokogiri'


# Using environment variables we don't have to provide them in this call
rds = AWS::RDS.new()

db_name=ENV['OPENSHIFT_APP_NAME']

# Add check to not create db instance twice

db = rds.client.create_db_instance(
                            :db_name => db_name,
                            :db_instance_identifier => db_name,
                            :allocated_storage => 5,
                            :db_instance_class => 'db.m1.medium',
                            :engine => 'mysql',
                            :master_username => 'admin',
                            :master_user_password => '12345678')


while rds.client.describe_db_instances(:db_instance_identifier => db_name).db_instances[0].db_instance_status == 'creating' do
    puts "creating db"
    sleep(5)
end

created_db = rds.client.describe_db_instances(:db_instance_identifier => db_name)

# Create new environment variables to function just like MYSQL would
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_HOST", 'w') { |file| file.write(db_created.db_instances[0].endpoint.address) }
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_PORT", 'w') { |file| file.write(db_created.db_instances[0].endpoint.port) }
