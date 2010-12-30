require  File.expand_path(File.dirname(__FILE__)) + "/../downloads_spec_helper"

describe DownloadsItemUser do

  reset_domain_tables :downloads_item, :downloads_item_user, :end_user, :end_user_cache

  it "should require download item and user" do
    @item = DownloadsItemUser.new
    @item.valid?

    @item.should have(1).error_on(:downloads_item_id)
    @item.should have(1).error_on(:end_user_id)
  end
end
