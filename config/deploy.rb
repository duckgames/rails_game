require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :application_name, 'rails_game'
set :domain, 'kev.church'
set :user, 'rails'
set :deploy_to, "/home/#{fetch(:user)}/rails_game"
set :repository, 'git@github.com:duckgames/rails_game.git'
set :branch, 'master'
set :rvm_path, '/home/rails/.rvm/scripts/rvm'

set :shared_dirs, fetch(:shared_dirs, []).push('log', 'storage', 'tmp/pids', 'tmp/sockets')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/puma.rb', 'config/master.key')
set :database_adapter, 'postgresql'
set :database_encoding, 'unicode'
set :database_pool, 5
set :database_host, 'localhost'
set :database_name, fetch(:application_name)
set :database_username, fetch(:user)

set :database_yml_string, %[production:\n adapter: #{fetch(:database_adapter)}\n encoding: #{fetch(:database_encoding)}\n pool: #{fetch(:database_pool)}\n host: #{fetch(:database_host)}\n database: #{fetch(:database_name)}\n password: \n username: #{fetch(:database_username)}]

set :puma_environment, 'production'
set :puma_bind, %[unix:#{fetch(:shared_path)}/tmp/sockets/puma.sock]
set :puma_pidfile, %[#{fetch(:shared_path)}/tmp/pids/puma.pid]
set :puma_state_path, %[#{fetch(:shared_path)}/tmp/sockets/puma.state]
set :puma_directory, %[#{fetch(:deploy_to)}/current]
set :puma_workers, 2
set :puma_threads, '1,4'
set :puma_daemonize, true
set :puma_stdout, %[#{fetch(:shared_path)}/log/puma.stdout.log]
set :puma_stderr, %[#{fetch(:shared_path)}/log/puma.stderr.log]
set :puma_activate_control_app, %[unix:#{fetch(:shared_path)}/tmp/sockets/pumactl.sock]

set :puma_rb_string, %[environment "#{fetch(:puma_environment)}"\n\nbind "#{fetch(:puma_bind)}"\npidfile "#{fetch(:puma_pidfile)}"\nstate_path "#{fetch(:puma_state_path)}"\ndirectory "#{fetch(:puma_directory)}"\n\nworkers #{fetch(:puma_workers)}\nthreads #{fetch(:puma_threads)}\ndaemonize #{fetch(:puma_daemonize)}\n\nstdout_redirect "#{fetch(:puma_stdout)}", "#{fetch(:puma_stderr)}"\n\nactivate_control_app "#{fetch(:puma_activate_control_app)}"\n\nprune_bundler]

task :remote_environment do
  invoke :'rvm:use', 'ruby-2.6.3@default'
end

task :setup do

  in_path(fetch(:shared_path)) do
    command %[mkdir -p config]

    command %[createdb #{fetch(:application_name)}]
    command %[touch "#{fetch(:shared_path)}/config/database.yml"]
    command %[echo -e '#{fetch(:database_yml_string)}' > #{fetch(:shared_path)}/config/database.yml]

    command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
    command %[echo -e '#{fetch(:puma_rb_string)}' > #{fetch(:shared_path)}/config/puma.rb]

    command %[chmod -R o-rwx config]
    command %{rvm install ruby-2.6.3}
    command %{gem install bundler}
  end
end

desc "Deploys the current version to the server."
task :deploy do
  invoke :'git:ensure_pushed'
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
       invoke :'puma:restart'
    end
  end
end