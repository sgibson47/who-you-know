class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :contact_interactions, class_name: 'ContactInteractions'
  has_many :interactions, through: :contact_interactions
  has_many :notes

  validates :name, presence: {message: "A contact must have a name."}
end