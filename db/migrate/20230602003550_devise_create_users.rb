# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :phone,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.integer :gender
      t.integer :desired_gender
      t.boolean :premium, null: false, default: false
      t.string :role, null: false, default: 'user'

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.text :bio, null: false, default: ""
      t.boolean :verified, null: false, default: false
      t.string :school, null: false, default: ""


      t.timestamps null: false
    end

    add_index :users, :phone,   unique: true
    add_index :users, :premium
    # add_index :users, :unlock_token,         unique: true
  end
end
