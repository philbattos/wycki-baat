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
                          inclusion: { :in => JSON.parse(ENV['SUPPORTED_SUBDOMAINS']), message: "'%{value}' is not a valid wiki destination." }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :page_templates,      -> { where name: 'Model Stubs' }
  scope :volume_templates,    -> { where name: 'Models' }
  scope :volume_pages,        -> { where.not(name: ['Model Stubs', 'Models']) }

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
    puts "starting Volume.save_volumes_and_texts...."
    puts "wiki: #{wiki.inspect}"
    puts "collection_id: #{collection_id}"
    Volume.transaction do
      files.each do |file|
        path = extract_path(file)
        puts "path: #{path.inspect}"
        root, *categories, volume_name, text_name = path.split('/') # EXAMPLE: wikipages/volume1/*/text-name
        puts "root: #{root.inspect}"
        puts "categories: #{categories.inspect}"
        puts "volume_name: #{volume_name.inspect}"
        puts "text_name: #{text_name.inspect}"

        raise IOError, "Wrong directory selected. Please select 'Content' instead of '#{root}'." unless root.match(/\AContent.*\z/)

        if valid_file_type?(text_name)
          puts "valid_file_type: #{text_name.inspect}"
          text_name.slice!('.txt')
        else # not a .txt file
          send_alert_message(file)
          next
        end

        volume = Volume.find_or_create_by!(name: volume_name, destination: wiki, collection_id: collection_id)
        puts "volume created: #{volume.inspect}"
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

    def self.valid_file_type?(text)
      valid_types = [ '.txt' ]
      file_type   = File.extname(text) unless text.nil?
      valid_types.include? file_type
    end

    def self.send_alert_message(file)
      ActionCable.server.broadcast 'alerts',
        message: "Wrong file type. #{file.original_filename} not saved because it is not a .txt file.",
        html_class: "info"
    end

end
