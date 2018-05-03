class AddColumnsToTvShow < ActiveRecord::Migration[5.1]
  def change
    add_column :tv_shows, :number_of_seasons, :integer
    add_column :tv_shows, :poster_path, :string
  end
end
