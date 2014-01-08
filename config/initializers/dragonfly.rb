require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret ENV['DRAGONFLY_SECRET_KEY']

  url_host ENV['DRAGONFLY_URL_HOST']

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public', 'system', 'dragonfly', Rails.env),
    server_root: Rails.root.join('public', 'system', 'dragonfly', Rails.env)
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
