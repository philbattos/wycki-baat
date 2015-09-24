class BaatsController < ApplicationController
  # include ActionController::Live

  def index
    @baat     = Baat.new
    # @model = Model.new
    # @content     = Content.new
    # @pdf_original    = PdfOriginal.new
    # @image    = Image.new
  end

  def create
    files     = params[:files]
    baat_type = params[:baat][:type]
    wiki      = params[:baat][:destination]
    baat      = baat_type.classify.constantize.new(baat_params)
    # baat.create_pages(files, baat.destination)

    case baat_type
    when 'model'
      raise 'NOT IMPLEMENTED YET'
      # Model.build_templates(params)
    when 'content'
      Volume.delete_all
      if Volume.save_volumes_and_texts(files)
        flash[:success] = "Volumes & Texts saved to database"
        flash[:notice] = "Volumes & Texts sent to background jobs to for uploading..."
        WorkerManager.perform_async(wiki) # it may be helpful to have a high-level worker so that we can track the upload progress
      else
        flash[:error] = "There was a problem saving some Volumes or Texts"
        # error in saving volumes & texts
      end
    end

    # verify that folder/files look correct
    # folder_confirmation(selected_folder)

    # $redis.publish('messages.create', @message.to_json)

    respond_to do |format|
      format.html { redirect_to "/" }
    end
  end

  # def events
  #   response.headers["Content-Type"] = "text/event-stream"
  #   10.times do |n|
  #     # Message.uncached do
  #     #   Message.where('created_at > ?', start).each do |message|
  #     #     response.stream.write "data: #{message.to_json}\n\n"
  #     #     start = Time.zone.now
  #     #   end
  #     # end
  #     response.stream.write "data: Text ##{n} uploaded. \n\n"
  #     sleep 1
  #   end
  # rescue IOError
  #   logger.info "Stream closed"
  # ensure
  #   response.stream.close
  # end

#=================================================
  private
#=================================================
    # Never trust parameters from the scary internet, only allow the white list through.
    def baat_params
      params.require(:baat).permit(:name, :destination)
    end

    def folder_confirmation(files)
      directories = files.map do |f|
        f.headers.match(/(.+filename=\")(.+)(\"\r\n.+)/)[2].split('/')
      end

      depth = directories.max.count
      directories.reject! {|d| d.include? ".DS_Store" }
      messages = []
      if directories.any? {|d| d.count < depth} # selected directory has subdirectories
        messages << "wrong number of subdirectories"
      end
      if directories.map {|d| d.first}.uniq.count > 1
        messages << "too many first-level directories"
      end
      if directories.map {|d| d.second}.uniq.count > 1
        messages << "too many second-level directories"
      end
    end

end
