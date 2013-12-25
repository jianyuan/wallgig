source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use puma as the app server
gem 'puma'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.0.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-puma', github: 'seuros/capistrano-puma'
end

# Use Foreman to manage the app
gem 'foreman'

# Use debugger
# gem 'debugger', group: [:development, :test]

# development and test
group :development, :test do
  # specs
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'ffaker'

  # utilities
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'spork-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-sidekiq'
  gem 'guard-spork'
  gem 'rb-inotify'
end

# auth
gem 'devise'
gem 'cancan'
gem 'omniauth'
gem 'omniauth-facebook'

# admin
gem 'activeadmin', github: 'gregbell/active_admin'

# models
gem 'friendly_id', '~> 5.0.0'
gem 'workflow', github: 'geekq/workflow'
gem 'dragonfly', '~> 1.0.0'
gem 'country_select'
gem 'enumerize'
gem 'kaminari'
gem 'acts-as-taggable-on'
gem 'impressionist'
gem 'paper_trail', '~> 3.0.0'
gem 'ancestry'
gem 'acts_as_list'

# views
gem 'slim'
gem 'haml-rails'
gem 'simple_form'
gem 'eco'

# assets
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails', github: 'anjlab/bootstrap-rails'
gem 'bourbon'
gem 'jquery-turbolinks'

# services
gem 'newrelic_rpm'
gem 'sidekiq', github: 'mperham/sidekiq'
gem 'sidetiq', github: 'tobiassvn/sidetiq'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'doorkeeper', '~> 0.7.0'
gem 'tire'

# utilities
gem 'dotenv-rails'
gem 'pry-rails'
gem 'miro'
gem 'color'
gem 'colorscore'
gem 'httparty'
gem 'rails_autolink'
gem 'active_link_to'
gem 'meta-tags', :require => 'meta_tags'
# gem 'phashion'

# rack
gem 'rack-cache', require:  'rack/cache', group: :production
