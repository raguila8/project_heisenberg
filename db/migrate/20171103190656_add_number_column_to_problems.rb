class AddNumberColumnToProblems < ActiveRecord::Migration[5.1]
  def change
		add_column :problems, :number, :integer
  end
end
