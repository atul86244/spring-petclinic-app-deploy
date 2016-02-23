#
# Cookbook Name:: java_app_deploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node.default['java']['jdk_version'] = "7"

# Install Java
include_recipe 'java'

#node.default['tomcat']['base_version'] = 7

# Install Tomcat
include_recipe 'tomcat'

tomcat_webapps_dir = node['tomcat']['webapp_dir']
tomcat_service_name = node['tomcat']['base_instance']

# Clean webapps folder
directory "#{tomcat_webapps_dir}/petclinic" do
  action :delete
  recursive true
end

# Download war to tomcat webapps
remote_file "#{tomcat_webapps_dir}/petclinic.war.zip" do
  owner 'root'
  group 'root'
  mode '0775'
  source 'https://s3-us-west-2.amazonaws.com/atul-java-app/petclinic.war'
  notifies :run, 'execute[rename_petclinic.war.zip]'
end

execute 'rename_petclinic.war.zip' do
  command 'mv -f petclinic.war.zip petclinic.war'
  cwd tomcat_webapps_dir
  action :nothing
  notifies :restart, "service[#{tomcat_service_name}]"
end

service tomcat_service_name do
  action :nothing
end

