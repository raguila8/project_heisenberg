class AddOccupationAndSchoolAndNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :occupation, :string
    add_column :users, :school, :string
  end
end
