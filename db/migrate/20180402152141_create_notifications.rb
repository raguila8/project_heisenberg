class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
			t.integer :user_id, index: true
			t.integer :notified_by_id, index: true
			t.integer :post_id, index: true
			t.integer :comment_id, index: true
			t.string :notification_type
			t.boolean :read, default: false

      t.timestamps
    end
  end
end
