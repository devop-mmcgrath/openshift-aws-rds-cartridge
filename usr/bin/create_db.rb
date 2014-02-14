#!/usr/bin/env ruby

require 'aws-sdk'
require 'nokogiri'

def generate_random(size = 10)
    charset = %w{ a b c d e f g h i j k l m n p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N P Q R S T U V W X Y Z }
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
end


# Using environment variables we don't have to provide them in this call
rds = AWS::RDS.new()

db_name=ENV['OPENSHIFT_APP_NAME']
openshift_mysql_db_username='admin' + generate_random(7)
openshift_mysql_db_password=generate_random(12)

# Add check to not create db instance twice

db = rds.client.create_db_instance(
                            :db_name => db_name,
                            :db_instance_identifier => db_name,
                            :allocated_storage => 5,
                            :db_instance_class => 'db.m1.medium',
                            :engine => 'mysql',
                            :master_username => openshift_mysql_db_username,
                            :master_user_password => openshift_mysql_db_password)


while rds.client.describe_db_instances(:db_instance_identifier => db_name).db_instances[0].db_instance_status == 'creating' do
    puts "creating db"
    sleep(5)
end

created_db = rds.client.describe_db_instances(:db_instance_identifier => db_name)

# Create new environment variables to function just like MYSQL would
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_HOST", 'w') { |file| file.write(created_db.db_instances[0].endpoint.address) }
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_PORT", 'w') { |file| file.write(created_db.db_instances[0].endpoint.port) }
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_USERNAME", 'w') { |file| file.write(openshift_mysql_db_username) }
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_PASSWORD", 'w') { |file| file.write(openshift_mysql_db_password) }
File.open(ENV['OPENSHIFT_AWSRDS_DIR']+"/env/OPENSHIFT_MYSQL_DB_URL", 'w') { |file| file.write("mysql://#{openshift_mysql_db_username}:#{}openshift_mysql_db_password@#{created_db.db_instances[0].endpoint.address}:#{created_db.db_instances[0].endpoint.port}/") }
