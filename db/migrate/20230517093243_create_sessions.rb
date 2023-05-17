class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.date :data
      t.text :comment
      t.string :obs_code

      t.timestamps
    end
  end
end
