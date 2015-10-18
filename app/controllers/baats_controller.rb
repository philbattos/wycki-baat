class BaatsController < ApplicationController

  def index
    @baat = Baat.new
  end

  def create
    collection      = params[:baat][:collection]
    collection_name = collection.blank? ? 'UNKNOWN-COLLECTION' : collection
    upload_type     = params[:baat][:type]
    wiki            = params[:baat][:destination]
    volumes         = params[:volume_files]
    templates       = params[:template_files]
    pdfs            = params[:pdf_files]
    images          = params[:images]

    collection = Collection.find_or_create_by!(name: collection_name, destination: wiki)

    case upload_type
    when 'templates'
      Template.destroy_all
      response = Template.save_templates(templates, wiki, collection.id)
      if response == true
        flash[:notice] = "The selected Templates have been saved to the database and are being dispatched to background jobs for uploading."
        TemplateUploader.perform_async(wiki)
      else # error in saving template
        error = response.to_s
        flash[:error] = "There was a problem saving a Template. (#{error}) No files were uploaded."
      end
    when 'volume-texts'
      Volume.destroy_all # this is done to keep the Heroku database small (and free)
      response = Volume.save_volumes_and_texts(volumes, wiki, collection.id)
      if response == true
        flash[:notice] = "The selected Volumes & Texts have been saved to the database and are being dispatched to background jobs for uploading."
        VolumeTextUploader.perform_async(wiki)
      else # error in saving volumes & texts
        error = response.to_s
        flash[:error] = "There was a problem saving some Volumes or Texts. (#{error}) No files were uploaded."
      end
    when 'pdfs'
      response = PdfOriginal.save_files(pdfs, wiki, collection)
      if response == true
        flash[:notice] = "The selected PDFs have been saved to the database and are being dispatched to background jobs for uploading."
        PDFUploader.perform_async(wiki)
      else # error in saving PDFs
        error = response.to_s
        flash[:error] = "There was a problem saving some PDFs. (#{error}) No files were uploaded."
      end
    when 'images'
      response = Image.save_files(images, wiki, collection)
      if response == true
        flash[:notice] = "The selected images have been saved to the database and are being dispatched to background jobs for uploading."
        ImageUploader.perform_async(wiki)
      else # error in saving images
        error = response.to_s
        flash[:error] = "There was a problem saving some images. (#{error}) No files were uploaded."
      end
    end

    # verify that folder/files look correct
    # folder_confirmation(selected_folder)

    redirect_to :back
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
