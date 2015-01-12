# config valid only for Capistrano 3.1
lock '3.3.5'

set :pty, true
set :application, 'changhon'
set :deploy_user, 'vpsadmin'
set :deploy_to, "/var/www/#{fetch :application}"

set :scm, :git
set :repo_url, 'git@github.com:rfestag/nexuscms.git'

# Default value for keep_releases is 5
set :keep_releases, 5

# Default value for :linked_files is []
#set :linked_files, %w{config/mongoid.yml config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

template %w(mongoid.yml 
            application.yml 
            unicorn.rb 
            unicorn_init.sh)
set(:config_files, %w(
  nginx.conf
  mongoid.yml
  application.yml
  log_rotation
  monit
  unicorn.rb
  unicorn_init.sh
))

set(:executable_config_files, %w(
  unicorn_init.sh
))
set :tests, []

set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
  },
  {
    source: "monit",
    link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
  }
])

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup', 'nginx:remove_default_vhost'
end
