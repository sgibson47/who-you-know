class RenameContactIdColumnInNotes < ActiveRecord::Migration
  def change
    rename_column(:notes, :cotnact_id, :contact_id)
  end
end
