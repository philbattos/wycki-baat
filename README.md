# wycki-baat
A tool for automating the creation of wiki pages

## Steps for Starting App in Development
- start ActionCable server (puma): `./bin/cable`
- start app server (webrick): `rails server`
- start redis: `redis-server`
- start workers (sidekiq): `sidekiq`
- open localhost:3000 in browser