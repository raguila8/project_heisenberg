class CreateProblemAttributions < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_attributions do |t|
      t.string :source_type
      t.string :author
      t.string :link
      t.integer :problem_id

      t.timestamps
    end
  end
end
