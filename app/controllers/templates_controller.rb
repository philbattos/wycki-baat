class TemplatesController < ApplicationController

  def create
    collection      = params[:template][:collection_name]
    collection_name = collection.blank? ? 'UNKNOWN-COLLECTION' : collection
    wiki            = params[:template][:destination]
    templates       = params[:template_files]

    collection = Collection.find_or_create_by!(name: collection_name, destination: wiki)

    Template.destroy_all

    if Template.save_templates(templates, wiki, collection.id)
      flash[:notice] = "The selected Templates have been saved to the database and are being dispatched to background jobs for uploading."
      TemplateUploader.perform_async(wiki)
    else # error in saving template
      error = response.to_s
      flash[:error] = "There was a problem saving a Template. (#{error}) No files were uploaded."
    end

    redirect_to action: 'index'
  end

#=================================================
  private
#=================================================

    def template_params
      params.require(:template).permit(:name, :destination, :collection_name, :type)
    end

end