class PdfOriginalsController < ApplicationController
  before_action :set_s3_direct_post, only: [:new, :index, :create]

  def index
    @pdf_originals = PdfOriginal.all
  end

  def new
    @pdf_original = PdfOriginal.new
  end

  def create
    @pdf_original = PdfOriginal.new
  end

#=================================================
  private
#=================================================
    def set_s3_direct_post
      # @s3_direct_post = S3_BUCKET.presigned_post( key:                    "uploads/#{SecureRandom.uuid}/${filename}",
      #                                             success_action_status:  '201',
      #                                             acl:                    'public-read' )
    end

end