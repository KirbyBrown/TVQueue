class CreateJoinTableListEpisode < ActiveRecord::Migration[5.1]
  def change
    create_join_table :lists, :episodes do |t|
      t.index [:list_id, :episode_id]
      t.index [:episode_id, :list_id]

      t.boolean :viewed
    end
  end
end
