class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.boolean :read, :default => false
			t.belongs_to :conversation, index: true
			t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
