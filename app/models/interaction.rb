class Interaction < ActiveRecord::Base
  belongs_to :user
  has_many :contact_interactions
  has_many :contacts, through: :contact_interactions
  has_many :notes
end
