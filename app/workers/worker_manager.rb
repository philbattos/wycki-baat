class WorkerManager
  include Sidekiq::Worker

  def perform(wiki)
    templates = Volume.templates
    volumes   = Volume.non_templates
    volumes.each do |vol|
      # create batching??
      vol_num = vol.name.match(/\d+/)[0]
      # upload_templates(wiki, vol_num, templates)
      upload_texts(wiki, vol)
    end
  end

#=================================================
  private
#=================================================

    # def upload_templates(wiki, volume_number, templates)
    #   templates.each do |template|
    #     VolumeUploader.perform_async(wiki, volume_number, template)
    #   end
    # end

    def upload_texts(wiki, volume)
      volume.texts.each do |text|
        TextUploader.perform_async(wiki, text.id)
      end
    end

end
