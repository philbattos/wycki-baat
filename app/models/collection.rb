class Collection < ActiveRecord::Base
  has_many :volumes
  has_many :templates

end
