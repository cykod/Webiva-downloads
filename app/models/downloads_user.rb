

class DownloadsUser < DomainModel

  belongs_to :downloads_item
  belongs_to :end_user


  def self.push_user(downloads_item_id,end_user_id)
    itm = self.find_by_downloads_item_id_and_end_user_id(downloads_item_id,end_user_id)
    itm.update_attribute(:updated_at, Time.now) if itm

    DownloadsItemUser.allow_user_id(downloads_item_id,end_user_id)
    
    itm ||= self.create(:downloads_item_id => downloads_item_id, :end_user_id => end_user_id)
  end


end
