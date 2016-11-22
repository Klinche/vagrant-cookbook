#
# Cookbook Name:: Vagrant
# Recipe:: ruby
#
# Copyright 2015, Klinche
#
# All rights reserved - Do Not Redistribute
#


search('aws_opsworks_app', 'deploy:true').each do |app|

release_user = node[:deploy]["#{app[:shortname]}"][:release_user]
release_group = node[:deploy]["#{app[:shortname]}"][:release_group]


script 'Vagrant Use Ruby 2.1.6' do
  interpreter 'bash'
  cwd '/vagrant'
  user release_user
  environment  'HOME' => "/home/#{release_user}"
  code <<-EOH
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    usermod -a -G rvm #{release_user}
    rvm install ruby-2.1.6 || true
    rvm --default use 2.1.6
    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    rvm get head
    rvm requirements
    rvm --default use 2.1.6
    EOH
end

ruby_block 'set new ruby for chef run' do
  block { ENV['PATH'] = "/home/#{release_user}/.rvm/gems/ruby-2.1.6/bin:/home/#{release_user}/.rvm/gems/ruby-2.1.6@global/bin:/home/#{release_user}/.rvm/rubies/ruby-2.1.6/bin:#{ENV['PATH']}:/home/#{release_user}/.rvm/bin" }
  not_if { ENV['PATH'].include?('rvm') }
end
end
