App.messages = App.cable.subscriptions.create 'AlertsChannel',
  received: (data) ->
    $('#upload-alerts').append @renderAlert(data)
    $('#upload-progress').append @listUploadedFile(data) unless data.html_class == 'info'

  renderAlert: (data) ->
    "<div class='alert alert-#{data.html_class} fade in'> #{data.message} </div>"

  listUploadedFile: (data) ->
    "<li class='text-#{data.html_class}'><#{data.text_decoration}> #{data.page_type}: <a href=#{data.url} target='_blank'>#{data.page_name}</a> </#{data.text_decoration}></li>"
