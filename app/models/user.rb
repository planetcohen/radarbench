class User < ActiveRecord::Base
  include Identifiable
  include SoftDeletable

  has_many :bookmarks
  has_many :videos, through: :bookmarks

  validates :email, presence: true,
                    uniqueness: {scope: :deleted_at},
                    format: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  #validates :fb_uid, uniqueness: {scope: :deleted_at}
  #validates :tw_uid, uniqueness: {scope: :deleted_at}
  
  attr_accessible :email, :first_name, :last_name, :fb_uid, :fb_access_token, :tw_uid, :tw_access_token

  def full_name
    "#{first_name} #{last_name}"
  end
end
