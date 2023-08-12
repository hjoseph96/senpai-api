
namespace :setup do
    desc "setup: copy config/master.key to shared/config"
    task :copy_linked_master_key do
      on roles(fetch(:setup_roles)) do
        sudo :mkdir, "-pv", shared_path
        upload! "config/master.key", "#{shared_path}/config/master.key"
        sudo :chmod, "600", "#{shared_path}/config/master.key"
      end
    end
    before "deploy:symlink:linked_files", "setup:copy_linked_master_key"
  end