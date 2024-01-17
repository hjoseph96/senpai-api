class ChangeMessageContentToOptional < ActiveRecord::Migration[7.1]
  def change
    rename_column :messages, :content, null: true
  end
end
