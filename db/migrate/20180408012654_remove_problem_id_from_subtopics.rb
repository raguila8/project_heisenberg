class RemoveProblemIdFromSubtopics < ActiveRecord::Migration[5.1]
  def change
    remove_column :subtopics, :problem_id, :integer
  end
end
