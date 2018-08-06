class RenameEducationToEmployer < ActiveRecord::Migration
  def change
    rename_column(:contacts, :education, :employer)
  end
end
