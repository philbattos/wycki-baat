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
    # Never trust parameters from the scary internet, only allow the white list through.
    def baat_params
      params.require(:baat).permit(:name, :destination)
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post( key:                    "uploads/#{Time.now.strftime('%Y%^b%d-%^A%H%M-%S%L')}/${filename}",
                                                  success_action_status:  '201',
                                                  acl:                    'public-read' )
    end

    # def folder_confirmation(files)
    #   directories = files.map do |f|
    #     f.headers.match(/(.+filename=\")(.+)(\"\r\n.+)/)[2].split('/')
    #   end

end
