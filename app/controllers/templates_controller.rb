class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit]

  # GET /templates
  # GET /templates.json
  def index
    @template = Template.new
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    @template = Template.new
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    template = Template.new(template_params)
    selected_folder = params[:text_files]

    # verify that folder/files look correct
    # messages = folder_confirmation(@selected_folder)
    messages = []

    selected_folder.each do |file|
      response = template.create_page(file, template.destination)
      messages << response.warnings
      messages << response.data
      messages << "#{file.original_filename} has been uploaded \n"
    end

    messages.each do |msg|
      flash[:notice] = msg
    end

    respond_to do |format|
      # if @template.save
      #   format.html { redirect_to @template, notice: 'Template was successfully created.' }
      #   format.json { render :show, status: :created, location: @template }
      # else
      #   format.html { render :new }
      #   format.json { render json: @template.errors, status: :unprocessable_entity }
      # end
      format.html { redirect_to '/templates' }
    end
  end

#=================================================
  private
#=================================================
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:name, :destination)
    end

    def folder_confirmation(selected_folder)
      directories = selected_folder.map do |f|
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
      messages
    end

end
