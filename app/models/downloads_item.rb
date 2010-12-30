
class DownloadsItem < DomainModel
  has_domain_file :domain_file_id
  has_many :downloads_item_users, :dependent => :delete_all

  validates_presence_of :domain_file_id, :name

  def allow_user(user)
    self.downloads_item_users.find_by_end_user_id(user.id) || self.downloads_item_users.create(:end_user_id => user.id)
  end

  def revoke_user(user)
    item_user = self.downloads_item_users.find_by_end_user_id(user.id)
    item_user.destroy if item_user
  end

  def can_download?(user)
    self.downloads_item_users.find_by_end_user_id(user.id) ? true : false
  end

  def num_allowed_users
    @num_allowed_users ||= self.downloads_item_users.count
  end
end
