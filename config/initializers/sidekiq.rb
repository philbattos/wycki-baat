# These settings calculated from: http://manuelvanrijn.nl/sidekiq-heroku-redis-calc/

Sidekiq.configure_client do |config|
  config.redis = { size: 1, network_timeout: 5 }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 5, network_timeout: 5 }
end