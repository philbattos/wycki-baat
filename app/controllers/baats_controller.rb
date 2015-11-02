class BaatsController < ApplicationController
  before_action :set_s3_direct_post, only: [:index]

  def index
    @baat     = Baat.new
    @template = Template.new
    @volume   = Volume.new
    @pdf      = PdfOriginal.new
    @image    = Image.new
  end

  def create
    # collection      = params[:baat][:collection]
    # collection_name = collection.blank? ? 'UNKNOWN-COLLECTION' : collection
    # upload_type     = params[:baat][:type]
    # wiki            = params[:baat][:destination]

    # collection = Collection.find_or_create_by!(name: collection_name, destination: wiki)

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

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post( key:                    "uploads/#{SecureRandom.uuid}/${filename}",
                                                  success_action_status:  '201',
                                                  acl:                    'public-read' )
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
