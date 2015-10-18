class Text < ActiveRecord::Base
  include AASM # state machine

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  belongs_to :volume

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------
  validates :name,  presence: true,
                    format: { with: /\A[^.].+$\z/, message: "Text name must not start with a dot(.)" }
  validates :destination, presence: true,
                          inclusion: { :in => %w[ librarywiki terzod research ], message: "'%{value}' is not a valid wiki destination. Please enter 'librarywiki', 'terdzod', or 'research'" }
  validates :file_name, format: { with: /\A(?![.]DS_Store).+\z/, message: "Text file name must not contain '.DS_Store'" }
  validates :file_root, presence: true,
                        format: { with: /\AContent.*\z/, message: "The selected folder containing volumes and texts should start with 'Content'. It looks like you selected something else. You should select a different folder or rename the selected folder to start with 'Content'." }

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :txt_files, -> { where file_extension: '.txt' }

  #-------------------------------------------------
  #    States
  #-------------------------------------------------
  aasm do
    state :new, initial: true
    state :uploaded
    state :failure

    event :successful_upload do
      transitions from: :new, to: :uploaded
    end

    event :failed_upload do
      transitions from: :new, to: :failure
    end
  end


end
