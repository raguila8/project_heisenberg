class AddProblemAssociationToTopics < ActiveRecord::Migration[5.1]
  def change
		add_reference :topics, :problem, index: true
		add_foreign_key :topics, :problems
  end
end
