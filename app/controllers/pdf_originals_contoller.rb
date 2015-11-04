class PdfOriginalsController < ApplicationController

  def index
    @pdf_originals = PdfOriginal.all
  end

  def create
    collection_name = params[:collection_name]
    wiki            = params[:destination]
    collection      = Collection.find_or_create_by!(name: collection_name, destination: wiki)

    if @pdf = collection.pdf_originals.create(pdf_params)
      PDFUploader.perform_async(@pdf.id)
      flash[:notice] = "The selected PDF has been saved to the database and is being dispatched a background job for uploading."
    else
      flash[:error] = "There was a problem saving a PDF. Please try again. (#{error})"
    end

    redirect_to '/'
  end

#=================================================
  private
#=================================================
    def pdf_params
      params.permit(:name, :destination, :api_response, :pdf_file, :collection_name, categories: [])
    end

end