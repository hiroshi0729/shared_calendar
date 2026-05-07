class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'pending'

      t.timestamps
    end
    
    # 同じユーザー同士の重複申請を防ぐ
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
