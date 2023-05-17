class AddToDatasets < ActiveRecord::Migration[6.1]
  def change
    add_reference :datasets, :source, index: true
    add_reference :datasets, :band, index: true
    add_reference :datasets, :session, index: true
  end
end
