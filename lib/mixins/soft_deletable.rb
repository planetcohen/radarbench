module SoftDeletable
  def self.included(base)
    base.send :default_scope, base.where(:deleted_at => nil)
    base.scope :deleted, base.where('deleted_at is not null')
  end
  
  # Instance Methods:
  def soft_destroy
    update_attribute :deleted_at, Time.now
  end
  
  def soft_deleted?
    deleted_at.present?
  end
end
