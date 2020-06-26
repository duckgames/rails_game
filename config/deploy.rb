require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :application_name, 'rails_game'
set :domain, '161.35.45.157'
set :user, 'rails'
set :deploy_to, "/home/#{fetch(:user)}/rails_game"
set :repository, 'git@github.com:duckgames/rails_game.git'
set :branch, 'master'
set :rvm_path, '/home/rails/.rvm/scripts/rvm'

set :shared_dirs, fetch(:shared_dirs, []).push('log', 'storage', 'tmp/pids', 'tmp/sockets')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/puma.rb', 'config/master.key')

task :remote_environment do
  invoke :'rvm:use', 'ruby-2.6.3@default'
end

task :setup do
  
  in_path(fetch(:shared_path)) do
    command %[mkdir -p config]
    command %[touch "#{fetch(:shared_path)}/config/database.yml"]
    command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
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