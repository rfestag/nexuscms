def add_user user, group: nil, home: nil, system_account: false
  cmd = ["useradd"]
  cmd << "-U #{group}" if group
  cmd << "-d #{home}" if home
  cmd << "-r" if system_account
  puts "Testing to add user"
  begin
    execute %Q{test -n "`getent passwd | grep #{user}`"}
  rescue
    info " Adding #{user}"
    sudo %Q{#{cmd.join ' '} #{user}}
  else 
    info " #{user} already exists"
  end
end
def add_user_to_group user, group
  begin
    execute %Q{test -n "`getent group | grep #{group} | grep #{user}`"}
  rescue
    info " Adding #{user} to #{group}"
    sudo %Q{usermod -a -G #{group} #{user}}
  else
    info " #{user} is already in #{group}"
  end
end
def remove_user_from_group user, group
  groups = capture("groups vpsadmin | awk -F ':' '{print $2}' | sed s/#{group}//")
  new_groups = groups.split.join(',')
  sudo %Q{"test -n '`getent group | grep #{group} | grep #{user}`' ||  usermod -G #{new_groups} #{user}"}
end
