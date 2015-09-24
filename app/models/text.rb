class Text < ActiveRecord::Base
  include AASM # state machine

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------
  belongs_to :volume

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------
  validates :file_name, format: { with: /\A(?![.]DS_Store).+\z/, message: "Text file name must not contain '.DS_Store'" }

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
