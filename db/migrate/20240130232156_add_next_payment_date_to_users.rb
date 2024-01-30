class AddNextPaymentDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :next_payment_date, :datetime
  end
end
