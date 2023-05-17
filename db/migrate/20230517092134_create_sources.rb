class CreateSources < ActiveRecord::Migration[6.1]
  def change
    create_table :sources do |t|
      t.string :be1950name
      t.string :alt_name
      t.string :ra
      t.string :decl
      t.text :comment
      t.string :atca_link
      t.string :source_type
      t.float :redshift

      t.timestamps
    end
  end
end
