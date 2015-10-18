require 'fileutils'

class PdfOriginal < ActiveRecord::Base

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
  def self.save_files(pdfs, wiki, collection)
    directory = 'public/uploads/pdfs'
    pdfs.each do |pdf|
      path = extract_path(pdf)
      root, *categories, filename = path.split('/')
      raise IOError, "Wrong directory selected. Please select 'PDFs' instead of '#{root}'." unless root.match(/\APDFs\z/)
      filepath = File.join(directory, collection.name, categories)
      create_category_folders(filepath)
      filepath = File.join(filepath, filename)
      File.open(filepath, 'wb') { |file| file.write(pdf.read) }
      puts "File uploaded: #{filename}"
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