class AddObservationToDatasets < ActiveRecord::Migration[6.1]
  def change
    add_reference :datasets, :observation, index: true
    add_reference :datasets, :user, index: true
  end
end
