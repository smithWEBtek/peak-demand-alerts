class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
    	t.integer :possible_min
    	t.integer :possible_max

      t.timestamps null: false
    end
  end
end
