class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :posts
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

end
