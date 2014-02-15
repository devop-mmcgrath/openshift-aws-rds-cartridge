# OpenShift RDS Cartridge
This cartridge is documented in the [Cartridge Guide](http://openshift.github.io/documentation/oo_cartridge_guide.html#phpmyadmin).

# Requirements
This cartridge requires you to have an AWS account as well as an access key/private key.  By installing this cartridge, those keys will be used to create a database that is managed by OpenShift.  You will have to pay for the RDS costs.

# Install
Step 1 is to upload your AWS keys to OpenShift so the cartridge can use them.  Use environment variables for this:

    rhc env set AWS_ACCESS_KEY_ID='YOURKEYID' AWS_SECRET_ACCESS_KEY='YOURSECRETKEY' 

Step 2 is to install the cartridge:

   cartridge add -a MYAPP https://github.com/mmcgrath-openshift/openshift-aws-rds-cartridge/raw/master/metadata/manifest.yml

# Usage
Usage of this cartridge is idential to the MySQL cartridge provided by OpenShift except there is no local socket available.

# Special Note
When removed, this cartridge will destroy the database associated with this application and create a snapshot of it.  Keep in mind until the snapshot is cleaned up you will incur AWS charges on your AWS bill so keep that in mind.
