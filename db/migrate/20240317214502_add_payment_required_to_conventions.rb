class AddPaymentRequiredToConventions < ActiveRecord::Migration[7.1]
  def change
    add_column :conventions, :payment_required, :boolean, null: false, default: true
    add_index :conventions, :payment_required
  end
end
