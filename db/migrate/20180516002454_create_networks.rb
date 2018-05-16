class CreateNetworks < ActiveRecord::Migration[5.1]
  def change
    create_table :networks do |t|
      t.integer :tmdb_id
      t.string :name
      t.string :logo_path

      t.timestamps
    end
  end
end
