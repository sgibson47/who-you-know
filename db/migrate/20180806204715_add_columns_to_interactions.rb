class AddColumnsToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :location, :string
    add_column :interactions, :time, :integer
  end
end
