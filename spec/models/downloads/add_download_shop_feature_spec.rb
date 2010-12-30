require File.expand_path(File.dirname(__FILE__)) + "/../../downloads_spec_helper"
require 'shop/shop_order'
require File.expand_path(File.dirname(__FILE__)) + "/../../../../shop/spec/models/shop/shop_order_process_spec"

describe Downloads::AddDownloadShopFeature do
  it_should_behave_like "General Order Process"

  reset_domain_tables :shop_product_feature, :downloads_item, :downloads_item_user

  # Go through the order process with a test payment processor
  before(:each) do
    create_test_payment_processor # from ShopOrderProcessHelper
    @membership = Shop::ShopProduct.create(:name => 'Awesome Download', :price_values => { 'USD' => 25.00 })
  end
  
  it "should be able to add rewards to the user" do
    @download = DownloadsItem.create :domain_file_id => 2, :name => 'My Download'
    @feature = @membership.shop_product_features.build :position => 0, :feature_options => {:download_item_id => @download.id}, :purchase_callback => 1
    @feature.shop_feature_handler = Downloads::AddDownloadShopFeature.to_s.underscore
    @feature.save
    @membership.update_attribute :purchase_callbacks, 1

    @membership.shop_product_features.count.should == 1
    @feature.should_not be_nil
    @feature.purchase_callback.should be_true
    @feature.shop_product_id.should == @membership.id

    @cart.add_product(@membership, 1)
    
    @order = create_order(@cart)

    @transaction = @order.authorize_payment(:remote_ip => '127.0.0.1' )
    
    @transaction.should be_success
    @order.state.should == 'authorized'
    
    @order.total.should == 25.00

    @capture_transaction = @order.capture_payment
    @capture_transaction.should be_success
    @order.state.should == 'paid'

    assert_difference 'DownloadsItemUser.count', 1 do
      session = {}
      @order.post_process(@user,session)
    end

    @item_user = DownloadsItemUser.last
    @item_user.end_user_id.should == @user.id
  end
end
