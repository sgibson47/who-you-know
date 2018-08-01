class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :contact_interactions
  has_many :interactions, through: :contact_interactions
  has_many :notes
end