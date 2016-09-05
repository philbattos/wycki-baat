$ ->
  $('#imageUploadForm').find('input:file').each (i, elem) ->
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
        file          = data.files[0]
        fileTypes     = /(\.|\/)(gif|jpe?g|png)$/i
        expectedRoot  = /Image.*/i
        # selectedRoot  = file.webkitRelativePath.split('/')[0]
        # if expectedRoot.test(selectedRoot)
        console.log "file.webkitRelativePath: #{file.webkitRelativePath if file}"
        if fileTypes.test(file.type) || fileTypes.test(file.name)
          data.submit()
        else
          alert("#{file.name} is not an image file")
        # else alert("Wrong directory selected. Please select the Images folder instead of #{selectedRoot}")
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        progressBar.css 'width', progress + '%'
        if progress == 100
          submitButton.prop 'disabled', false
          progressBar.text 'Images Saved'
      start: (e) ->
        submitButton.prop 'disabled', true
        progressBar.css('background', 'green').css('display', 'block').css('width', '0%').text 'Saving...'
        return
      done: (e, data) ->
        # extract key, generate URL from response, and save filename to db
        key           = $(data.jqXHR.responseXML).find('Key').text()
        url           = 'https://' + form.data('host') + '/' + key
        uploadedFile  = key.split('/').pop()
        fileName      = uploadedFile.replace('.jpg', '')
        collection    = $('#image_collection_name').val()
        destination   = $('#image_destination').val()
        [root, categories..., target] = data.files[0].webkitRelativePath.split('/')
        $.ajax
          type: 'POST'
          url: '/images'
          dataType: 'json'
          data:
            image_file: url.replace(/\s/, '')
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
