

# frozen_string_literal: true

class AddRegularPriceToVariations < ActiveRecord::Migration[7.1]
  def up
    add_column    :variations, :regular_price, :float
    add_column    :products, :regular_price, :float
  end

  def down
    remove_column :variations, :regular_price
    remove_column :products, :regular_price
  end
end
