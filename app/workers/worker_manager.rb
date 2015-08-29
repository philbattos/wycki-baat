class WorkerManager
  include Sidekiq::Worker

  def perform(volumes, templates, wiki)
    volumes.each do |vol, files|
      # create batching??
      vol_num = vol.match(/\d+/)[0]
      upload_templates(wiki, vol_num, templates)
      upload_texts(wiki, vol, files)
    end
    # total 100 # by default
    # at 5, "Almost done"
  end

#=================================================
  private
#=================================================

    def upload_templates(wiki, volume_number, templates)
      templates.each do |template|
        VolumeUploader.perform_async(wiki, volume_number, template)
      end
    end

    def upload_texts(wiki, volume, texts)
      texts.each do |text|
        TextUploader.perform_async(wiki, volume, text)
      end
    end

end
