root = "/var/www/sic"
working_directory root
pid "#{root}/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"
 
#listen "#{root}/pids/unicorn.almoxarifado.sock"
listen "/tmp/unicorn.sic.sock"
worker_processes 2
timeout 600
 
# Force the bundler gemfile environment variable to
# # reference the capistrano "current" symlink
#before_exec do |_|
#  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
#end
