class Collection < ActiveRecord::Base
  has_many :templates
  has_many :volumes
  has_many :pdf_originals
  has_many :images

end
