class RenameConfigsToConfigurations < ActiveRecord::Migration
  def change
    rename_table :configs, :configurations
  end
end
