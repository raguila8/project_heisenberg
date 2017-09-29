class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations do |t|
      t.belongs_to :sender, class: 'User', index: true
      t.belongs_to :recipient, class: 'User', index: true

      t.timestamps
    end
  end
end
