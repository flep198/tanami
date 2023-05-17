class CreateDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :datasets do |t|
      t.string :image
      t.string :uvf
      t.float :rms
      t.float :lowest_contour
      t.float :peak_flux
      t.float :beam_maj
      t.float :beam_min
      t.float :beam_pos

      t.timestamps
    end
  end
end
