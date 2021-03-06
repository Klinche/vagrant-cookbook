search('aws_opsworks_app', 'deploy:true').each do |app|
  Chef::Log.info("********** Starting To Create Database Mysql: '#{app[:name]}' **********")

  root_user = node[:deploy][(app[:shortname]).to_s][:database][:database_user]
  root_pass = node[:deploy][(app[:shortname]).to_s][:database][:database_password]
  port = node[:deploy][(app[:shortname]).to_s][:database][:database_port]
  name = node[:deploy][(app[:shortname]).to_s][:database][:database_name]
  host = node[:deploy][(app[:shortname]).to_s][:database][:database_host]

  # master
  mysql_service "default" do
    port port
    version '5.7'
    bind_address '0.0.0.0'
    initial_root_password root_pass
    action [:create, :start]
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



