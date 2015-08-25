class BaatsController < ApplicationController

  # GET /baats
  # GET /baats.json
  def index
    @baat     = Baat.new
    # @template = Template.new
    # @volume   = Volume.new
    # @text     = Text.new
    # @folio    = Folio.new
    # @image    = Image.new
  end

  # POST /baats
  # POST /baats.json
  def create
    files     = params[:files]
    baat_type = params[:baat][:type]
    # wiki      = params[:baat][:destination]
    baat      = baat_type.classify.constantize.new(baat_params)

    baat.create_pages(files)

    # verify that folder/files look correct
    # folder_confirmation(selected_folder)

    # messages = folder_confirmation(@selected_folder)
    # messages.each do |msg|
    #   flash[:notice] = msg
    # end

    respond_to do |format|
      # if @baat.save
      #   format.html { redirect_to @baat, notice: 'Baat was successfully created.' }
      #   format.json { render :show, status: :created, location: @baat }
      # else
      #   format.html { render :new }
      #   format.json { render json: @baat.errors, status: :unprocessable_entity }
      # end
      format.html { redirect_to "/" }
    end
  end

#=================================================
  private
#=================================================
    # Never trust parameters from the scary internet, only allow the white list through.
    def baat_params
      params.require(:baat).permit(:name, :destination)
    end

    def folder_confirmation(files)
      directories = files.map do |f|
        f.headers.match(/(.+filename=\")(.+)(\"\r\n.+)/)[2].split('/')
      end

      depth = directories.max.count
      directories.reject! {|d| d.include? ".DS_Store" }
      messages = []
      if directories.any? {|d| d.count < depth} # selected directory has subdirectories
        messages << "wrong number of subdirectories"
      end
      if directories.map {|d| d.first}.uniq.count > 1
        messages << "too many first-level directories"
      end
      if directories.map {|d| d.second}.uniq.count > 1
        messages << "too many second-level directories"
      end
    end

end
