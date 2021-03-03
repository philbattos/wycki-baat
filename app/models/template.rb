class Template < ActiveRecord::Base
  include AASM # state machine

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------
  validates :name,  presence: true,
                    format: { with: /\A[^.].+$\z/, message: "Template name must not start with a dot(.)" }
  validates :destination, presence: true,
                          inclusion: { :in => ENV['SUPPORTED_SUBDOMAINS'], message: "'%{value}' is not a valid wiki destination." }
  validates :file_root, presence: true,
                        format: { with: /\ATemplates\z/, message: "The selected folder containing templates should be named 'Templates'. It looks like you selected something else." }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------

  #-------------------------------------------------
  #    States
  #-------------------------------------------------
  aasm do
    state :new, initial: true
    state :started
    state :completed
    state :failed

    event :start_upload do
      transitions from: :new, to: :started
    end

    event :complete_upload do
      transitions from: :started, to: :completed
    end

    event :failed_upload do
      transitions from: :started, to: :failed
    end
  end

  #-------------------------------------------------
  #    Public Methods
  #-------------------------------------------------
  def self.save_templates(files, wiki, collection_id)
    # verify that all files are .txt files so that we don't try to save/upload images or pdfs
    Template.transaction do
      files.each do |file|
        path = extract_path(file)
        root, *categories, text_name = path.split('/') # EXAMPLE: Templates/*/Main_Page.txt
        raise IOError, "Wrong directory selected. Please select 'Templates' instead of '#{root}'." unless root.match(/\ATemplates\z/)
        is_skippable?(text_name) ? next : text_name.slice!('.txt')
        Template.create!(
          collection_id:  collection_id,
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
    puts "ERROR in Template model: #{validation_error}"
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
