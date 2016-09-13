# web: bundle exec rails server -p $PORT

web: bundle exec puma -t 0:5 -p $PORT
worker: bundle exec sidekiq -C config/sidekiq.yml -e production