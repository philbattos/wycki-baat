# These settings calculated from: http://manuelvanrijn.nl/sidekiq-heroku-redis-calc/
#
# The 'size' setting was removed in 2020 based on this error (in Heroku) and solution:
#   https://stackoverflow.com/questions/48313434/when-i-increase-sidekiq-concurrency-it-says-my-pool-is-too-small-but-smaller-n

Sidekiq.configure_client do |config|
  config.redis = { size: 1, network_timeout: 7 }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 9, network_timeout: 7 }
end