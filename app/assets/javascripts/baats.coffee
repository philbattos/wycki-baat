# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  flashCallback = ->
    $(".alert-success").delay(5000).fadeOut(2000)
    setTimeout flashCallback, 500
  setTimeout flashCallback, 1000

  listProgress = ->
    $()



#-------------------------------------------------
#    Streaming (ActionController::Live)
#-------------------------------------------------
# source = new EventSource('/baats/events')
# source.addEventListener 'message', (e) ->
#   message = e.data
#   # console.log $.parseJSON e.data
#   # console.log $.parseJSON(e.data).message
#   # message = $.parseJSON(e.data).message
#   $('#progress-alert').append($('<li>').text("#{message}"))
#   # alert e.data