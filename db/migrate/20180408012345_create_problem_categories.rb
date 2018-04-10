class CreateProblemCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_categories do |t|
      t.belongs_to :problem, index: true
      t.belongs_to :subtopic, index: true

      t.timestamps
    end
  end
end
