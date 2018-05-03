class AddStillPathToEpisode < ActiveRecord::Migration[5.1]
  def change
    add_column :episodes, :still_path, :string
  end
end
