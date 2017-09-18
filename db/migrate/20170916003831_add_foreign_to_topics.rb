class AddForeignToTopics < ActiveRecord::Migration[5.1]
  def change
    add_reference :topics, :forum, index: true
  end
end
