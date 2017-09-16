class AddTitleToProblems < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :title, :string
  end
end
