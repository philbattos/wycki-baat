class WikiBotsController < ApplicationController

  def index
    @bots = WikiBot.all
    @template = Template.new
    @volume   = Volume.new
    @text     = Text.new
    @folio    = Folio.new
    @image    = Image.new
    @wiki_bot = WikiBot.new
  end

  # POST /wiki_bots
  # POST /wiki_bots.json
  def create
    # @bot = WikiBot.new(site_url: params[:site_url])
    # @template = Template.new(template_params)
    @selected_folder = params[:text_files]

    # verify that folder/files look correct
    directories = @selected_folder.map do |f|
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

    respond_to do |format|
      # if @template.save
      #   format.html { redirect_to @template, notice: 'Template was successfully created.' }
      #   format.json { render :show, status: :created, location: @template }
      # else
      #   format.html { render :new }
      #   format.json { render json: @template.errors, status: :unprocessable_entity }
      # end
      format.html { redirect_to "/", notice: messages }
    end
  end

end
