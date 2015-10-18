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
  validates :name,  presence: true,
                    format: { with: /\A[^.].+$\z/, message: "Volume name must not start with a dot(.)" }
  validates :destination, presence: true,
                          inclusion: { :in => %w[ librarywiki terzod research ], message: "'%{value}' is not a valid wiki destination. Please enter 'librarywiki', 'terdzod', or 'research'" }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :page_templates,      -> { where name: 'Model Stubs' }
  scope :volume_templates,    -> { where name: 'Models' }
  # scope :templates,           -> { where name: ['Model Stubs', 'Models'] }
  scope :volume_pages,        -> { where.not(name: ['Model Stubs', 'Models']) }
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
  def self.save_volumes_and_texts(files, wiki, collection_id)
    # verify that all files are .txt (or .rtf) files so that we don't try to save/upload images or pdfs
    Volume.transaction do
      files.each do |file|
        path = extract_path(file)
        root, *categories, volume_name, text_name = path.split('/') # EXAMPLE: wikipages/volume1/*/text-name
        raise IOError, "Wrong directory selected. Please select 'Content' instead of '#{root}'." unless root.match(/\AContent.*\z/)
        is_skippable?(text_name) ? next : text_name.slice!('.txt')
        volume = Volume.find_or_create_by!(name: volume_name, destination: wiki, collection_id: collection_id)
        volume.texts.create!(
          name:           text_name,
          destination:    wiki,
          file_path:      file.path,
          content:        File.foreach(file.path).to_a.join(''),
          file_extension: File.extname(file.path),
          file_size:      File.size(file.path),
          file_headers:   file.headers,
          file_name:      file.original_filename,
          file_root:      root,
          categories:     categories
        )
      end
    end
    true # volumes and texts were saved without errors
  rescue ActiveRecord::RecordInvalid => validation_error
    puts "ERROR in Volume model: #{validation_error}"
    validation_error
  rescue IOError => input_error
    input_error
  end

#=================================================
  private
#=================================================

    def self.extract_path(file)
      file.headers.match(/(filename=)("(.+)")/).captures.last
    end

    def self.is_skippable?(text)
      blacklist = [ nil, '.DS_Store' ]
      blacklist.include? text
    end

end
