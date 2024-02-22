class CreateUserConventions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_conventions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :convention, null: false, foreign_key: true

      t.timestamps
    end
  end
end
