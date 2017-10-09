class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.integer :friend_id
      t.timestamps
    end

    add_reference :friendships, :user, index: true, foreign_key: {on_delete: :cascade}
  end
end
