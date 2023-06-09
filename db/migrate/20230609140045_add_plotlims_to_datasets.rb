class AddPlotlimsToDatasets < ActiveRecord::Migration[6.1]
  def change
    add_column :datasets, :ra_min, :float
    add_column :datasets, :ra_max, :float
    add_column :datasets, :dec_min, :float
    add_column :datasets, :dec_max, :float
  end
end
