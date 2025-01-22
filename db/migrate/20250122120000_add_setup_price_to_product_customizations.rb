# frozen_string_literal: true

class AddSetupPriceToProductCustomizations < ActiveRecord::Migration[7.1]
  def up
    add_column :product_customizations, :setup_price, :float
  end

  def down
    remove_column :product_customizations, :setup_price
  end
end
