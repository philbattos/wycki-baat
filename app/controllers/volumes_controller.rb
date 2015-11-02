class VolumesController < ApplicationController

  def create
    collection      = params[:volume][:collection_name]
    collection_name = collection.blank? ? 'UNKNOWN-COLLECTION' : collection
    wiki            = params[:volume][:destination]
    volumes         = params[:volume_files]

    collection = Collection.find_or_create_by!(name: collection_name, destination: wiki)

    Volume.destroy_all # this is done to keep the Heroku database small (and free)

    if Volume.save_volumes_and_texts(volumes, wiki, collection.id)
      flash[:notice] = "The selected Volumes & Texts have been saved to the database and are being dispatched to background jobs for uploading."
      VolumeTextUploader.perform_async(wiki)
    else # error in saving volumes & texts
      error = response.to_s
      flash[:error] = "There was a problem saving some Volumes or Texts. (#{error}) No files were uploaded."
    end

    redirect_to action: 'index'
  end

#=================================================
  private
#=================================================

    def volume_params
      params.require(:volume).permit( :name,
                                      :destination,
                                      :collection_name,
                                      :type,
                                      :content,
                                      :api_response )
    end

end