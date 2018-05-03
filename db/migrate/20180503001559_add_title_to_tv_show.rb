class AddTitleToTvShow < ActiveRecord::Migration[5.1]
  def change
    add_column :tv_shows, :title, :string
  end
end
