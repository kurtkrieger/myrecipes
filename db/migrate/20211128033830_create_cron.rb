class CreateCron < ActiveRecord::Migration[5.0]
  def change
    drop_table :cronreport_distributions
    drop_table :cronreports
    drop_table :lookups
    drop_table :users
    
    create_table :lookups do |t|
      t.text :lookup_type
      t.text :short_name
    end
    create_table :cronreports do |t|
      t.integer :lookup_id
      t.text :name
    end
    create_table :users do |t|
      t.text :email
    end
    create_table :cronreport_distributions do |t|
      t.integer :cronreport_id
      t.integer :user_id
    end
  end
end
