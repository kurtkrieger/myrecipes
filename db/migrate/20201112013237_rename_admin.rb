class RenameAdmin < ActiveRecord::Migration[5.0]
  def change
    rename_column :chefs, :is_admin, :admin
  end
end
