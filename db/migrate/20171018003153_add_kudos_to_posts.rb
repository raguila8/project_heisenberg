class AddKudosToPosts < ActiveRecord::Migration[5.1]
  def change
		add_column :posts, :kudos, :integer, default: 0
  end
end
