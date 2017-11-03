class AddForeignToTopics < ActiveRecord::Migration[5.1]
  def change
    add_reference :topics, :forum, index: true, default: 1
  end
end
