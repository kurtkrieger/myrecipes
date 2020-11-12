class AddAdminToChef < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :is_admin, :boolean, default: false
  end
end
