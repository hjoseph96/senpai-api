class AddPaymentRequiredToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :payment_required, :boolean, default: false
    change_column :parties, :disbanded, :boolean, default: false

    add_index :events, :payment_required
    add_index :events, :cosplay_required
  end
end
