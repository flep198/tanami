class CreateObservations < ActiveRecord::Migration[6.1]
  def change
    create_table :observations do |t|
      t.references :source, index: true
      t.references :session, index: true
      t.references :band, index: true
      
      t.timestamps
    end
  end
end
