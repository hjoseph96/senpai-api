class AddDescriptionToConvention < ActiveRecord::Migration[7.1]
  def change
    add_column :conventions, :description, :text
  end
end
