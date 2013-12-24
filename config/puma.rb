environment 'production'
threads 0,16
workers %x{grep -c processor /proc/cpuinfo}.strip
bind 'unix:///var/run/wallgig.sock'
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end