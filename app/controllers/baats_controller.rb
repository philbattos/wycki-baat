class BaatsController < ApplicationController
  before_action :set_s3_direct_post, only: [:index]

  def index
    @baat     = Baat.new
    @template = Template.new
    @volume   = Volume.new
    @pdf      = PdfOriginal.new
    @image    = Image.new
  end

#=================================================
  private
#=================================================
    def baat_params
      params.require(:baat).permit(:name, :destination)
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post( key:                    "uploads/#{Time.now.strftime('%Y%^b%d-%^A%H%M-%S%L')}/${filename}",
                                                  success_action_status:  '201',
                                                  acl:                    'public-read' )
    end

end
