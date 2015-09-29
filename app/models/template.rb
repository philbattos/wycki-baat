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
                          inclusion: { :in => %w[ librarywiki terzod research ], message: "'%{value}' is not a valid wiki destination. Please enter 'librarywiki', 'terdzod', or 'research'" }

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
  def self.save_templates(files, wiki)
    # verify that all files are .txt files so that we don't try to save/upload images or pdfs
    Template.transaction do
      files.each do |file|
        path = extract_path(file)
        root, *categories, text_name = path.split('/') # EXAMPLE: Templates/*/Main_Page.txt
        is_skippable?(text_name) ? next : text_name.slice!('.txt')
        Template.create!(
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
