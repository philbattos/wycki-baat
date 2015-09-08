class Volume < ActiveRecord::Base

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  belongs_to :collection
  has_many :texts

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------
  validates :name, format: { with: /\A[^.].+$\z/, message: "Volume name must not start with a dot(.)" }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :metadata_templates,  -> { where name: 'Model Stubs' }
  scope :volume_templates,    -> { where name: 'Models' }
  scope :testing_templates,   -> { where name: 'templates' } # delete after testing
  scope :templates,           -> { where name: ['Model Stubs', 'Models', 'templates'] }
  scope :non_templates,       -> { where.not(name: [:templates]) }

  #-------------------------------------------------
  #    Public Methods
  #-------------------------------------------------
  def self.save_volumes_and_texts(files)
    # add batches & transactions?
    files.each do |file|
      path = extract_path(file)
      root, volume_name, *categories, text_name = path.split('/') # EXAMPLE: wikipages/volume1/*/text-name
      text_name.nil? ? next : text_name.slice!('.txt')
      volume = Volume.find_or_create_by(name: volume_name)
      volume.texts.create( # check if texts exist before creating?
        name:           text_name,
        file_path:      file.path,
        content:        File.open(file.path, 'rb').read,
        file_extension: File.extname(file.path),
        file_headers:   file.headers,
        file_name:      file.original_filename,
        file_root:      root,
        categories:     categories,
        # categories?
      )
    end
  end

#=================================================
  private
#=================================================

    def self.extract_path(file)
      file.headers.match(/(filename=)("(.+)")/).captures.last
    end

end
