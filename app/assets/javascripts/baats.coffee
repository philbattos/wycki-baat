# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  flashCallback = ->
    $(".alert-success").delay(5000).fadeOut(2000)
    setTimeout flashCallback, 500
  setTimeout flashCallback, 1000
