#= require cable
#= require_self
#= require_tree .

@App = {}

if railsEnv == 'development'
  App.cable = Cable.createConsumer 'ws://127.0.0.1:28080'
else # production
  App.cable = Cable.createConsumer 'wss://wyckibaat.herokuapp.com/'