class AddColumnsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :image_url, :string
    add_column :contacts, :email, :string
    add_column :contacts, :telephone, :string
    add_column :contacts, :slack, :string
    add_column :contacts, :git_hub_url, :string
    add_column :contacts, :linked_in_url, :string
    add_column :contacts, :twitter_url, :string
    add_column :contacts, :home_page_url, :string
    add_column :contacts, :education, :string
  end
end
