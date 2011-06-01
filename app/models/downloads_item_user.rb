
class DownloadsItemUser < DomainModel
  has_end_user :end_user_id
  belongs_to :downloads_item

  validates_presence_of :end_user_id, :downloads_item_id

  def self.allow_user_id(downloads_item_id,user_id)
    DownloadsItemUser.find_by_downloads_item_id_and_end_user_id(downloads_item_id,user_id) ||
      DownloadsItemUser.create(:downloads_item_id => downloads_item_id,
                               :end_user_id => user_id)

  end

  def item_name
    self.downloads_item ? self.downloads_item.name : '(None)'
  end

end
