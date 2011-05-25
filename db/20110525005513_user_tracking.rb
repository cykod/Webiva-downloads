class UserTracking < ActiveRecord::Migration
  def self.up
    create_table :downloads_users, :force => true do |t|
      t.integer :downloads_item_id
      t.integer :end_user_id
      t.timestamps
    end

    add_column :downloads_items, :category, :string
  end

  def self.down
    drop_table :downloads_users

    remove_column :downloads_items, :category
  end
end
