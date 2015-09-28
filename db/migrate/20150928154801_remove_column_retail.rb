class RemoveColumnRetail < ActiveRecord::Migration
  def change
    remove_column :orders, :retail_client
  end
end
