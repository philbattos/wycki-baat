source 'https://rubygems.org'
ruby '2.6.4' # used by Heroku

#-------------------------------------------------
#    Rails default gems
#-------------------------------------------------
gem 'rails',           '4.2.8'  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'sass-rails',   '~> 4.0.3'  # Use SCSS for stylesheets
gem 'uglifier',     '>= 1.3.0'  # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.0'  # Use CoffeeScript for .js.coffee assets and views

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

gem 'jquery-rails'                                  # Use jquery as the JavaScript library
gem 'turbolinks'                                    # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder',     '~> 2.0'                        # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc',         '~> 0.4.0', group: :doc         # bundle exec rake doc:rails generates the API under doc/api.
gem 'spring',                   group: :development # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]


#-------------------------------------------------
#    Added gems
#-------------------------------------------------
gem 'mediawiki_api'                             # for accessing the Media Wiki API (created by Wikimedia)
gem 'haml'                                      # alternative to html views
gem 'pg', '~> 0.20'                             # Heroku uses postgres
gem 'sidekiq'                                   # background jobs
gem 'sidekiq-status'                            # for tracking the status of background jobs in Sidekiq
gem 'sinatra', :require => nil                  # for Sidekiq UI wyckibaat.com/sidekiq
gem 'net-http-digest_auth'                      # for digest authentication (re: firewall on research.tsadra.org)
gem 'rest-client'                               # for making external http requests
# gem 'active_model_serializers'
gem 'puma'                                      # server that supports streaming and multiple async connections (ActionCable)
gem 'aasm'                                      # for tracking the state of uploaded objects (state_machine gem is neglected)
gem 'actioncable', github: 'rails/actioncable', branch: 'archive'
# gem 'yomu'                                      # for reading different types of files (ex. .rtf instead of .txt)
gem 'jquery-fileupload-rails'                   # for jquery-file-upload
gem 'aws-sdk'                                   # for direct uploads to S3
gem 'redis'                                     # for using Heroku Redis

group :production do
  gem 'newrelic_rpm'                            # for monitoring site performance
  gem 'rails_12factor'                          # for Heroku deployment
  gem 'rails_stdout_logging'                    # for capturing all logs on Heroku
  gem 'rails_serve_static_assets'               # enables Rails server to deliver assets on Heroku
end

group :development, :test do
  gem 'dotenv-rails'                            # for storing environment variables
  gem 'rspec-rails', '~> 3.0'                   # for testing
  gem 'pry'                                     # for investigation & debugging
  gem 'web-console', '~> 2.0'                   # web console for debugging
end