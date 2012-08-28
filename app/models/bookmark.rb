class Bookmark < ActiveRecord::Base
  include Identifiable
  include SoftDeletable

  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true

  attr_accessible :user, :user_id, :video, :video_id
end
