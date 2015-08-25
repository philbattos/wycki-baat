source 'https://rubygems.org'
ruby '2.2.2' # used by Heroku

#-------------------------------------------------
#    Rails default gems
#-------------------------------------------------
gem 'rails',           '4.2.1'  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
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
gem 'rest-client'                           # for making external http requests
gem 'mediawiki_api'                         # for accessing the Media Wiki API (created by Wikimedia)
gem 'haml'                                  # alternative to html views
gem 'pg'                                    # Heroku uses postgres
gem 'newrelic_rpm'                          # for monitoring site performance


group :development, :test do
  gem 'dotenv-rails'                        # for storing environment variables
  gem 'rspec-rails', '~> 3.0'               # for testing
  gem 'pry'                                 # for investigation & debugging
end