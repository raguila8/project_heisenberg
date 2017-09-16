class CreateSolvedProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :solved_problems do |t|
			t.belongs_to :user
			t.belongs_to :problem
      t.timestamps
    end
  end
end
