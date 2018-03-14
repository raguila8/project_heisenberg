class CreateSolvedProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :solved_problems do |t|
			t.belongs_to :user, index: true
			t.belongs_to :problem, index: true
      t.timestamps
    end
  end
end
