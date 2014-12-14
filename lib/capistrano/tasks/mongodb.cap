namespace :mongodb do
  desc "Install Mongodb (CentOS)"
  task "install" do
    uname = capture("uname -a")
    arch = (uname.include? 'x86_64')? 'x86_64' : 'i686' 
    smart_template 'mongo.repo', '/etc/yum.d/mongo.repo'
    sudo "yum clean all && yum install mongodb-org"
  end
  %w(start stop restart).each do |task_name|
    desc "#{task_name} Mongodb"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "service mongod #{task_name}"
      end
    end
  end
end
