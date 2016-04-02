#
# Cookbook Name:: Vagrant
# Recipe:: ruby
#
# Copyright 2015, Klinche
#
# All rights reserved - Do Not Redistribute
#

script 'Vagrant Use Ruby 2.1.6' do
  interpreter 'bash'
  cwd '/vagrant'
  user 'vagrant'
  environment  'HOME' => '/home/vagrant'
  code <<-EOH
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    usermod -a -G rvm vagrant
    rvm install ruby-2.1.6 || true
    rvm --default use 2.1.6
    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    rvm get head
    rvm requirements
    rvm --default use 2.1.6
    EOH
end

ruby_block 'set new ruby for chef run' do
  block { ENV['PATH'] = "/home/vagrant/.rvm/gems/ruby-2.1.6/bin:/home/vagrant/.rvm/gems/ruby-2.1.6@global/bin:/home/vagrant/.rvm/rubies/ruby-2.1.6/bin:#{ENV['PATH']}:/home/vagrant/.rvm/bin" }
  not_if { ENV['PATH'].include?('rvm') }
end
