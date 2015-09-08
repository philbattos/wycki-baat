class Text < ActiveRecord::Base

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  belongs_to :volume

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------
  validates :file_name, format: { with: /\A(?![.]DS_Store).+\z/, message: "Text file name must not contain '.DS_Store'" }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :txt_files, -> { where file_extension: '.txt' }



end
