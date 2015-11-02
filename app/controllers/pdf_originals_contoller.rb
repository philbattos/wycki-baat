class PdfOriginalsController < ApplicationController
  before_action :set_s3_direct_post, only: [:index, :create]

  def index
    @pdf_originals = PdfOriginal.all
  end

  def create
    collection_name = params[:collection_name]
    wiki            = params[:destination]
    collection      = Collection.find_or_create_by!(name: collection_name, destination: wiki)

    if pdf = collection.pdf_originals.create(pdf_params)
      # send pdf to worker
      PDFUploader.perform_async(pdf.id)
      flash[:notice] = "The selected PDFs have been saved to the database and are being dispatched to background jobs for uploading."
    else
      flash[:error] = "There was a problem saving a PDF. Please try again. (#{error})"
    end

    redirect_to action: 'index'
  end

#=================================================
  private
#=================================================
    def pdf_params
      params.permit(:name, :destination, :api_response, :pdf_url, :pdf_file, :collection_name)
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post( key:                    "uploads/#{SecureRandom.uuid}/${filename}",
                                                  success_action_status:  '201',
                                                  acl:                    'public-read' )
    end

end