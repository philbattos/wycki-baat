class BaatsController < ApplicationController

  def index
    @baat = Baat.new
  end

  def create
    files     = params[:files]
    baat_type = params[:baat][:type]
    wiki      = params[:baat][:destination]
    # baat      = baat_type.classify.constantize.new(baat_params)
    # baat.create_pages(files, baat.destination)

    case baat_type
    when 'templates'
      raise 'NOT IMPLEMENTED YET'
      # Model.build_templates(params)
    when 'volume-texts'
      Volume.destroy_all # this is done to keep the Heroku database small (and free)
      response = Volume.save_volumes_and_texts(files, wiki)
      if response == true
        flash[:notice] = "The selected Volumes & Texts have been saved to the database and are being dispatched to background jobs for uploading."
        VolumeTextUploader.perform_async(wiki)
      else # error in saving volumes & texts
        error = response.to_s
        flash[:error] = "There was a problem saving some Volumes or Texts. (#{error}.) No files were uploaded."
      end
    end

    # verify that folder/files look correct
    # folder_confirmation(selected_folder)

    respond_to do |format|
      format.html { redirect_to "/" }
    end
  end

#=================================================
  private
#=================================================
    # Never trust parameters from the scary internet, only allow the white list through.
    def baat_params
      params.require(:baat).permit(:name, :destination)
    end

    # def folder_confirmation(files)
    #   directories = files.map do |f|
    #     f.headers.match(/(.+filename=\")(.+)(\"\r\n.+)/)[2].split('/')
    #   end

    #   depth = directories.max.count
    #   directories.reject! {|d| d.include? ".DS_Store" }
    #   messages = []
    #   if directories.any? {|d| d.count < depth} # selected directory has subdirectories
    #     messages << "wrong number of subdirectories"
    #   end
    #   if directories.map {|d| d.first}.uniq.count > 1
    #     messages << "too many first-level directories"
    #   end
    #   if directories.map {|d| d.second}.uniq.count > 1
    #     messages << "too many second-level directories"
    #   end
    # end

end
