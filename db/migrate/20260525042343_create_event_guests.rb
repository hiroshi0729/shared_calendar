class CreateEventGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :event_guests do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # 同じユーザーを重複してゲストに追加できないようにする
    add_index :event_guests, [:event_id, :user_id], unique: true
  end
end
