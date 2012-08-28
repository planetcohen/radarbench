class Video < ActiveRecord::Base
  include Identifiable
  include SoftDeletable

  has_many :bookmarks
  has_many :users, through: :bookmarks

  validates :host_url, presence: true, uniqueness: {scope: :deleted_at}

  attr_accessible :host_url, :title, :description, :html, :width, :height, :thumbnail_url, :created_at, :updated_at, :deleted_at
end
