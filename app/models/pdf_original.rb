class PdfOriginal < ActiveRecord::Base
  include AASM # state machine

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  belongs_to :collection

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
  def self.save_files(pdfs, wiki, collection_id)
    directory = 'public/uploads/pdfs'
    pdfs.each do |pdf|
      name = pdf.original_filename
      path = File.join(directory, name)
      File.open(path, 'wb') { |file| file.write(pdf.read) }
      puts "File uploaded: #{name}"
    end
    true
  end

#=================================================
  private
#=================================================


end