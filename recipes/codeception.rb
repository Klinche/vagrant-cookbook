script 'Install Codeception' do
  interpreter 'bash'
  user 'vagrant'
  cwd '/vagrant'
  code <<-EOH
    rm -rf codecept.phar && exit 0
    wget http://codeception.com/codecept.phar
  EOH
end

# script "Enable XDebug" do
#   interpreter 'bash'
#   user 'root'
#   code <<-EOH
#       php5enmod xdebug
#   EOH
# end

#
# php_pear 'xdebug' do
#   version '2.4.0RC4'
#   action :upgrade
#   preferred_state 'beta'
# end
