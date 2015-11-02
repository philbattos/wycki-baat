require 'fileutils'

class Image < ActiveRecord::Base
  # mount_uploader :image_file, ImageStorage

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  # belongs_to :collection

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------

  #-------------------------------------------------
  #    States
  #-------------------------------------------------

  #-------------------------------------------------
  #    Public Methods
  #-------------------------------------------------
  def self.save_files(images, wiki, collection)
    directory = 'public/uploads/images'
    images.each do |image|
      path = extract_path(image)
      root, *categories, filename = path.split('/')
      raise IOError, "Wrong directory selected. Please select 'Images' instead of '#{root}'." unless root.match(/\AImages\z/)
      filepath = File.join(directory, collection.name, categories)
      create_category_folders(filepath)
      filepath = File.join(filepath, filename)
      File.open(filepath, 'wb') { |file| file.write(image.read) }
      puts "Image uploaded: #{filename}"
    end
    true
  rescue IOError => input_error
    input_error
  end

#=================================================
  private
#=================================================

    def self.extract_path(file)
      file.headers.match(/(filename=)("(.+)")/).captures.last
    end

    def self.create_category_folders(filepath)
      FileUtils.mkpath(filepath) unless File.exists? filepath
    end

end
