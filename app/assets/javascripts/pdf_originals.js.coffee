# jQuery ->
#   console.log $('.directupload')
#   $('.directupload').fileupload
#     dataType: "script"
#     add: (e, data) ->
#       types = /(\.|\/)(gif|jpe?g|png)$/i
#       console.log data.files
#       file = data.files[0]
#       console.log file
#       if types.test(file.type) || types.test(file.name)
#         data.context = $(tmpl("pdf-upload", file))
#         $('.directupload').append(data.context)
#         data.submit()
#       else
#         alert("#{file.name} is not a gif, jpeg, or png image file")
#     progress: (e, data) ->
#       console.log data
#       if data.context
#         progress = parseInt(data.loaded / data.total * 100, 10)
#         data.context.find('.bar').css('width', progress + '%')

$ ->
  $('#pdfUploadForm').find('input:file').each (i, elem) ->
    fileInput     = $(elem)
    form          = $(fileInput.parents('form:first'))
    submitButton  = form.find('input[type="submit"]')
    progressBar   = $('<div class=\'bar\'></div>')
    barContainer  = $('<div class=\'progress\'></div>').append(progressBar)
    fileInput.after barContainer
    fileInput.fileupload
      fileInput: fileInput
      url: form.data('url')
      type: 'POST'
      autoUpload: true
      formData: form.data('form-data')
      paramName: 'file'
      dataType: 'XML'
      replaceFileInput: false
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        progressBar.css 'width', progress + '%'
        if progress == 100
          submitButton.prop 'disabled', false
          progressBar.text 'Saving done'
          window.location.href = '/pdf_originals'
      start: (e) ->
        submitButton.prop 'disabled', true
        progressBar.css('background', 'green').css('display', 'block').css('width', '0%').text 'Loading...'
        return
      done: (e, data) ->
        # extract key, generate URL from response, and save filename to db
        key           = $(data.jqXHR.responseXML).find('Key').text()
        url           = 'https://' + form.data('host') + '/' + key
        uploadedFile  = key.split('/').pop()
        fileName      = uploadedFile.replace('.jpg', '')
        collection    = $('#pdf_original_collection_name').val()
        destination   = $('#pdf_original_destination').val()
        $.ajax
          type: 'POST'
          url: '/pdf_originals'
          dataType: 'json'
          data:
            pdf_url: url
            name: fileName
            destination: destination
            collection_name: collection
            success: ->
              console.log "#{fileName} uploaded"
              # $("#success-indicate").fadeIn().delay(4000).fadeOut();
        # activate upload button
        # submitButton.prop 'disabled', false
        # progressBar.text 'Saving done'
      fail: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.css('background', 'red').text 'Failed'
