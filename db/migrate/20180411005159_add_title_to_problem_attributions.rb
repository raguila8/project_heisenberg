class AddTitleToProblemAttributions < ActiveRecord::Migration[5.1]
  def change
    add_column :problem_attributions, :title, :string
  end
end
