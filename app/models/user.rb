class User < ActiveRecord::Base
  has_many :contacts
  has_many :interactions
  has_many :notes, through: :contacts
  has_many :notes, through: :interactions

  has_secure_password

  validates :email, :username, :password, presence: {message: "In order to signup, you must include an email, username, and password."}
  validates :username, uniqueness: {message: "That username has been taken. Please try another."}

  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end
end