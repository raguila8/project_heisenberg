class AddCountriesToUsers < ActiveRecord::Migration[5.1]
  def change
		add_column :users, :country, :string, default: ""
  end
end
