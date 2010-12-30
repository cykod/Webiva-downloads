class InitialSetup < ActiveRecord::Migration
  def self.up
    create_table :downloads_items, :force => true do |t|
      t.integer :domain_file_id
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :downloads_item_users, :force => true do |t|
      t.integer :downloads_item_id
      t.integer :end_user_id
      t.timestamps
    end

    add_index :downloads_item_users, :downloads_item_id
    add_index :downloads_item_users, :end_user_id
  end

  def self.down
    drop_table :downloads_items
    drop_table :downloads_item_users
  end
end
