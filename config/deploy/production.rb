set :bundle_without, [:development, :test]
set :server, 'hydrogen.locum.ru'
set :user, 'hosting_andres'
set :login, 'andres'
set :application, 'sofa'
set :unicorn_conf,    "/etc/unicorn/#{fetch(:application)}.#{fetch(:login)}.rb"
set :unicorn_pid,     "/var/run/unicorn/#{fetch(:user)}/#{fetch(:application)}.#{fetch(:login)}.pid"
set :shared_path, "/home/#{fetch(:user)}/projects/#{fetch(:application)}/shared"

role :app, "#{fetch(:user)}@#{fetch(:server)}"
role :web, "#{fetch(:user)}@#{fetch(:server)}"
role :db,  "#{fetch(:user)}@#{fetch(:server)}"

set :repo_url, 'git@bitbucket.org:andreslemik/omanager.git'
# set :branch, 'new_interface'

server fetch(:server), user: fetch(:user), roles: %w(web app), application: fetch(:application)
set :rvm_type, :auto
set :rvm_ruby_version, '2.2.2'
set :rails_env, 'production'
set :use_sudo, false

set :ssh_options,                     port: 22,
                                      user: fetch(:user),
                                      forward_agent: true
set :deploy_to, "/home/#{fetch(:user)}/projects/#{fetch(:application)}"
before 'deploy:updated', 'set_current_release'
task :set_current_release do
  on roles(:app) do
    set :current_release, fetch(:latest_release_directory)
  end
end

set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use #{fetch(:rvm_ruby_version)} do bundle exec unicorn_rails -Dc #{fetch(:unicorn_conf)})"
# - for unicorn -
namespace :deploy do
  unicorn_start_cmd = fetch(:unicorn_start_cmd)
  desc 'restart application'
  task :restart do
    on roles(:app), in: :sequence, waith: 5 do
      invoke 'deploy:unicorn:restart'
    end
  end

  task :temp_clear do
    on roles(:app) do
      execute :rake, 'tmp:cache:clear'
    end
  end

  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, waith: 10 do
      invoke 'deploy:cleanup_assets'
      invoke 'deploy:unicorn:restart'
    end
  end

  namespace :unicorn do
    def run_unicorn
      execute "(cd #{fetch(:deploy_to)}/current; rvm use #{fetch(:rvm_ruby_version)} do bundle exec unicorn -Dc #{fetch(:unicorn_conf)})"
    end

    desc 'Start unicorn'
    task :start do
      on roles(:app) do
        run_unicorn
      end
    end

    desc 'Stop unicorn'
    task :stop do
      on roles(:app) do
        execute "[ -f #{fetch(:unicorn_pid)} ] && kill -QUIT `cat #{fetch(:unicorn_pid)}`"
      end
    end

    desc 'Restart unicorn'
    task :restart do
      on roles(:app) do
        invoke 'deploy:unicorn:stop'
        invoke 'deploy:unicorn:start'
      end
    end
  end
end
