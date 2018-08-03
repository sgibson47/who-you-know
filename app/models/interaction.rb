class Interaction < ActiveRecord::Base
  belongs_to :user
  has_many :contact_interactions, class_name: 'ContactInteractions'
  has_many :contacts, through: :contact_interactions
  has_many :notes

  validates :date, presence: {message: "An interaction must have a date."}
end
