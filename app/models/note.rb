class Note < ActiveRecord::Base
  belongs_to :contact
  belongs_to :interaction

  validates :content, presence: {message: "A note must have content. Please add to the note."}
end