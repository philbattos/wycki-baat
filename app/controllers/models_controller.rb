class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit]

  # GET /models
  # GET /models.json
  def index
    @models = Model.all
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @model = Model.new
  end

  # GET /models/new
  def new
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
  end

  # POST /models
  # POST /models.json
  def create
    model = Model.new(model_params)
    selected_folder = params[:text_files]

    # verify that folder/files look correct
    # messages = folder_confirmation(@selected_folder)
    messages = []

    selected_folder.each do |file|
      response = model.create_page(file, model.destination)
      messages << response.warnings
      messages << response.data
      messages << "#{file.original_filename} has been uploaded \n"
    end

    messages.each do |msg|
      flash[:notice] = msg
    end

    respond_to do |format|
      # if @model.save
      #   format.html { redirect_to @model, notice: 'Model was successfully created.' }
      #   format.json { render :show, status: :created, location: @model }
      # else
      #   format.html { render :new }
      #   format.json { render json: @model.errors, status: :unprocessable_entity }
      # end
      format.html { redirect_to '/models' }
    end
  end

#=================================================
  private
#=================================================
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = Model.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      params.require(:model).permit(:name, :destination)
    end

end
