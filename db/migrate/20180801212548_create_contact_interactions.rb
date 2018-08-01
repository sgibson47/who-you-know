class CreateContactInteractions < ActiveRecord::Migration
  def change
    create_table :contact_interactions do |t|
      t.integer :contact_id
      t.integer :interaction_id
    end
  end
end
