class CreateEpisodes < ActiveRecord::Migration[5.1]
  def change
    create_table :episodes do |t|
      t.references :tv_show, foreign_key: true
      t.integer :season
      t.integer :episode_number
      t.date :airdate

      t.timestamps
    end
  end
end
