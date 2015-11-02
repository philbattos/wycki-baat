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
      add: (e, data) ->
        types = /(\.|\/)(pdf)$/i
        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          # data.context = $(tmpl("pdf-upload", file))
          # $('#pdfUploadForm').append(data.context)
          data.submit()
        else
          alert("#{file.name} is not a PDF file")
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        progressBar.css 'width', progress + '%'
        if progress == 100
          submitButton.prop 'disabled', false
          progressBar.text 'PDF Files Saved'
          # window.location.href = '/pdfs'
      start: (e) ->
        submitButton.prop 'disabled', true
        progressBar.css('background', 'green').css('display', 'block').css('width', '0%').text 'Saving...'
        return
      done: (e, data) ->
        # extract key, generate URL from response, and save filename to db
        key           = $(data.jqXHR.responseXML).find('Key').text()
        url           = 'https://' + form.data('host') + '/' + key
        uploadedFile  = key.split('/').pop()
        fileName      = uploadedFile.replace('.pdf', '')
        collection    = $('#pdf_original_collection_name').val()
        destination   = $('#pdf_original_destination').val()
        [root, categories..., target] = data.files[0].webkitRelativePath.split('/')
        $.ajax
          type: 'POST'
          url: '/pdfs'
          dataType: 'json'
          data:
            pdf_file: url
            name: fileName
            destination: destination
            collection_name: collection
            categories: categories
            success: ->
              console.log "#{fileName} uploaded"
              # $("#success-indicate").fadeIn().delay(4000).fadeOut();
        # activate upload button
        # submitButton.prop 'disabled', false
        # progressBar.text 'Saving done'
      fail: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.css('background', 'red').text 'Failed'
