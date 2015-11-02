class Collection < ActiveRecord::Base
  has_many :templates
  has_many :volumes
  has_many :pdf_originals

end
