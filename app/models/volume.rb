class Volume < ActiveRecord::Base
  include AASM # state machine

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  belongs_to :collection
  has_many :texts, dependent: :destroy

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------
  validates :name, format: { with: /\A[^.].+$\z/, message: "Volume name must not start with a dot(.)" }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :metadata_templates,  -> { where name: 'Model Stubs' }
  scope :volume_templates,    -> { where name: 'Models' }
  scope :templates,           -> { where name: ['Model Stubs', 'Models', 'templates'] }
  scope :volume_pages,        -> { where.not(name: ['Model Stubs', 'Models', 'templates']) }
    # TO DO: find volume pages associated with current upload; do not find pages from old uploads

  #-------------------------------------------------
  #    States
  #-------------------------------------------------
  aasm do
    state :new, initial: true
    state :started
    state :completed

    event :start_upload do
      transitions from: :new, to: :started
    end

    event :complete_upload do
      transitions from: :started, to: :completed
    end
  end

  #-------------------------------------------------
  #    Public Methods
  #-------------------------------------------------
  def self.save_volumes_and_texts(files)
    # add batches?
    # verify that all files are .txt files so that we don't try to save/upload images or pdfs
    Volume.transaction do
      files.each do |file|
        path = extract_path(file)
        root, volume_name, *categories, text_name = path.split('/') # EXAMPLE: wikipages/volume1/*/text-name
        text_name.nil? ? next : text_name.slice!('.txt') # if text is something irrelavant like DS_Store, skip to the next file
        volume = Volume.find_or_create_by(name: volume_name)
        volume.texts.create(
          name:           text_name,
          file_path:      file.path,
          content:        File.foreach(file.path).to_a.join(''),
          file_extension: File.extname(file.path),
          file_size:      File.size(file.path),
          file_headers:   file.headers,
          file_name:      file.original_filename,
          file_root:      root,
          categories:     categories,
          # categories?
        )
      end
    end
  end

#=================================================
  private
#=================================================

    def self.extract_path(file)
      file.headers.match(/(filename=)("(.+)")/).captures.last
    end

end