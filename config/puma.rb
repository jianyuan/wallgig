environment 'production'
threads 0,16
workers %x{grep -c processor /proc/cpuinfo}.strip
bind 'tcp://0.0.0.0:9000'
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end