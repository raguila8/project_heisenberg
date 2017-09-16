class AddSolvedAndScoreToUsers < ActiveRecord::Migration[5.1]
  def change
		add_column :users, :solved, :integer, default: 0
		add_column :users, :score, :integer, default: 0
  end
end
