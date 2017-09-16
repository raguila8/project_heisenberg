class AddSolvedByToProblems < ActiveRecord::Migration[5.1]
  def change
		add_column :problems, :solved_by, :integer, default: 0
  end
end
