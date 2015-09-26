App.messages = App.cable.subscriptions.create 'AlertsChannel',
  received: (data) ->
    # $('#messages').append @renderMessage(data)
    $('#upload-alerts').append @renderAlert(data)
    $('#upload-progress').append @listUploadedFiles(data)

  renderAlert: (data) ->
    # "<p> #{data.message} </p>"
    "<div class='alert alert-#{data.html_class} fade in'> #{data.message} </div>"

  listUploadedFiles: (data) ->
    "<li class='text-#{data.html_class}'><#{data.text_decoration}> #{data.page_type}: #{data.page_name} </#{data.text_decoration}></li>"
