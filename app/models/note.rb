class Note < ActiveRecord::Base
  belongs_to :contact
  belongs_to :interaction
end