class DeleteImageFromDatasets < ActiveRecord::Migration[6.1]
  def change
    remove_column :datasets, :image
    remove_column :datasets, :uvf
  end
end
