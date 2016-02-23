#
# Cookbook Name:: java_app_deploy
# Recipe:: audit_check.rb
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

control_group "Smoke Test for Java App" do
  control "ensure the application is running" do
      it 'should be listening' do
         expect(port(9966)).to be_listening.with('tcp')
      end
      it 'should respond to http requests' do
        expect(command('curl http://localhost:9966/petclinic').exit_status).to eq 0
      end
   end
end