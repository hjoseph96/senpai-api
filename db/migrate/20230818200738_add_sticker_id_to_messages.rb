class AddStickerIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :sticker_id, :integer
  end
end
