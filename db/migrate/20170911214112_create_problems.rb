class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.text :question
      t.float :answer
      t.integer :difficulty

      t.timestamps
    end
  end
end
