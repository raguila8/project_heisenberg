class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.text :question
      t.float :answer
      t.integer :difficulty
			t.integer :points
			t.integer :submissions, default: 0
      t.timestamps
    end
  end
end
