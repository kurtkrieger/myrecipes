class ChangeRecipesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :chef_id, :bigint
  end
end
