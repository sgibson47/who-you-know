class User < ActiveRecord::Base
  has_many :contacts
  has_many :interactions
  has_many :notes, through: :contacts
  has_many :notes, through: :interactions
end