class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :cotnact_id
      t.integer :interaction_id
      t.string :content

      t.timestamps null: false
    end
  end
end
