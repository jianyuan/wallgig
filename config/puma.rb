environment 'production'
# threads 8, 32
workers %x{grep -c processor /proc/cpuinfo}.strip
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end