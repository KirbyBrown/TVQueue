class CreateQueuedEpisodes < ActiveRecord::Migration[5.1]
  def change
    create_table :queued_episodes do |t|
      t.references :user, foreign_key: true
      t.references :episode, foreign_key: true
      t.boolean :viewed, null: false, default: false

      t.timestamps
    end

    add_index :queued_episodes, [:user_id, :episode_id], unique: true
  end
end
