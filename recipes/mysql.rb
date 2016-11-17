search('aws_opsworks_app', 'deploy:true').each do |app|
  Chef::Log.info("********** Starting To Create Database Mysql: '#{app[:name]}' **********")

  root_user = node[:deploy][(app[:shortname]).to_s][:database][:database_user]
  root_pass = node[:deploy][(app[:shortname]).to_s][:database][:database_password]
  port = node[:deploy][(app[:shortname]).to_s][:database][:database_port]
  name = node[:deploy][(app[:shortname]).to_s][:database][:database_name]
  host = node[:deploy][(app[:shortname]).to_s][:database][:database_host]

  mysql_service 'default' do
    action [:stop]
  end

  versionM = '5.6'
  versionM = '5.7' if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
  
  packageName = "mysql-server"
  packageName = 'mysql-server-5.7' if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
  
  packageVersion = nil
  #packageVersion = '5.7.13-0ubuntu0.16.04.2' if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'


  # master
  mysql_service "default" do
    port port
    version version
    bind_address '0.0.0.0'
    package_name packageName
    package_version packageVersion
    initial_root_password root_pass
    action [:create]
  end
  
  #The package installs a version of mysql and auto starts it which conflicts with us.
  execute 'stop old mysql' do
    command "/bin/systemctl --system stop mysql > /dev/null 2> /dev/null"
  end
  
  execute 'delete old mysql' do
    command "systemctl disable mysql > /dev/null 2> /dev/null"
  end
  
  mysql_service "default" do
    action [:start]     
  end
  
  execute 'drop database' do
    command "mysql -h #{host} -P #{port} --password=#{root_pass} -u #{root_user} -e 'drop database #{name}'; > /dev/null 2> /dev/null"
  end

  execute 'create database' do
    command "mysql -h #{host} -P #{port} --password=#{root_pass} -u #{root_user} -e 'create database #{name}'; > /dev/null 2> /dev/null"
  end

  execute 'Update permissions' do
    command "mysql -h #{host} -P #{port} --password=#{root_pass} -u #{root_user} -e \"GRANT ALL ON *.* to '#{root_user}'@'%' IDENTIFIED BY '#{root_pass}';\""
  end

end



