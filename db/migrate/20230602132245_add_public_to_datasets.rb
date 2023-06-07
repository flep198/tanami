class AddPublicToDatasets < ActiveRecord::Migration[6.1]
  def change
    add_column :datasets, :public, :boolean, default: false
  end
end
