class RemoveNumberFromProblems < ActiveRecord::Migration[5.1]
  def change
    remove_column :problems, :number, :integer
  end
end
