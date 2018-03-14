class CreateSubtopics < ActiveRecord::Migration[5.1]
  def change
    create_table :subtopics do |t|			
			t.belongs_to :problem, index: true
			t.belongs_to :branch, index: true
			t.string :name, index: true

      t.timestamps
    end
  end
end
