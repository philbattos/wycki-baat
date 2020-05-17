# These settings calculated from: http://manuelvanrijn.nl/sidekiq-heroku-redis-calc/

Sidekiq.configure_client do |config|
  config.redis = { size: 1, network_timeout: 7 }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 9, network_timeout: 7 }
end