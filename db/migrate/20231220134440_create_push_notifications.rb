class CreatePushNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :push_notifications do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.text :content
      t.string :event_name

      t.timestamps
    end
  end
end
