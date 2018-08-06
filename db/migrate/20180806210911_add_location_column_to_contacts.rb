class AddLocationColumnToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :location, :string
  end
end
