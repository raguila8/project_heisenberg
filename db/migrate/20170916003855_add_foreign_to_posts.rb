class AddForeignToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :topic, index: true
  end
end
