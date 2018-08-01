class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.date :date
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
