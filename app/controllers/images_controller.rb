class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def create
    collection_name = params[:collection_name]
    wiki            = params[:destination]
    collection      = Collection.find_or_create_by!(name: collection_name, destination: wiki)

    if @image = collection.images.create(image_params)
      ImageUploader.perform_async(@image.id)
      flash[:notice] = "The selected image has been saved to the database and is being dispatched a background job for uploading."
    else
      flash[:error] = "There was a problem saving an image. Please try again. (#{error})"
    end

    redirect_to '/'
  end

#=================================================
  private
#=================================================
    def image_params
      params.permit(:name, :destination, :api_response, :image_file, :collection_name, categories: [])
    end

end