
class DownloadsItemUser < DomainModel
  has_end_user :end_user_id
  belongs_to :downloads_item

  validates_presence_of :end_user_id, :downloads_item_id
end
