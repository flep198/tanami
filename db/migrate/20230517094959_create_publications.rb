class CreatePublications < ActiveRecord::Migration[6.1]
  def change
    create_table :publications do |t|
      t.text :authors
      t.string :title
      t.string :reference
      t.string :ads_link
      t.string :arxiv_link
      t.string :pdf_link

      t.timestamps
    end
  end
end
