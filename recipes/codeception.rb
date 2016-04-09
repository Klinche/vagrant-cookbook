script 'Install Codeception' do
  interpreter 'bash'
  user 'vagrant'
  cwd '/vagrant'
  code <<-EOH
    rm -rf codecept.phar && exit 0
    wget http://codeception.com/codecept.phar
  EOH
end

%w{php7.0-dev php-pear}.each do |pkg|
  script "Reconfigure all outstanding packages in case package before #{pkg} fails us" do
    interpreter 'bash'
    user 'root'
    code <<-EOH
        sudo dpkg --configure -a
    EOH
  end

  package pkg do
    timeout 4000
    action :upgrade
  end

  script "Reconfigure all outstanding packages in case #{pkg} fails us" do
    interpreter 'bash'
    user 'root'
    code <<-EOH
      sudo dpkg --configure -a
    EOH
  end
end

script "XDebug" do
  interpreter 'bash'
  user 'root'
  code <<-EOH
      pecl install xdebug
      rm -rf /etc/php/7.0/mods-available/xdebug.ini
      echo "zend_extension=xdebug.so" > /etc/php/7.0/mods-available/xdebug.ini
      echo "xdebug.remote_enable = on" >> /etc/php/7.0/mods-available/xdebug.ini
      echo "xdebug.remote_connect_back = on" >> /etc/php/7.0/mods-available/xdebug.ini
      echo "xdebug.idekey = 'vagrant'" >> /etc/php/7.0/mods-available/xdebug.ini
      echo "xdebug.remote_host = '192.168.33.1'" >> /etc/php/7.0/mods-available/xdebug.ini
      phpenmod xdebug
  EOH
end
