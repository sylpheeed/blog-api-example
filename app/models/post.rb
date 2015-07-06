class Post < ActiveRecord::Base
  belongs_to :user
  enum status: [:hidden, :active]
  default_scope { active }
  paginates_per 10

  validates :user_id, presence: true
  validates :title, presence: true
  validates :preview, presence: true
  validates :text, presence: true
end
