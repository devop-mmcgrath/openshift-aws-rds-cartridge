#!/usr/bin/env ruby

require 'aws-sdk'
require 'nokogiri'


# Using environment variables we don't have to provide them in this call
rds = AWS::RDS.new()

db_name=ENV['OPENSHIFT_APP_NAME']+"db"


# Create a snapshot of database on remove
db = rds.client.delete_db_instance(
    :db_instance_identifier => db_name,
    :final_db_snapshot_identifier => db_name + '-' + Time.now.to_i.to_s)

puts "DB Instance Status: " + db.db_instance_status

