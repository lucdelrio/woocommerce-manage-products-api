# frozen_string_literal: true

class CreateProductCustomizations < ActiveRecord::Migration[7.1]
  def up
    create_table :product_customizations do |t|
      t.integer    :zecat_product_id
      t.integer    :woocommerce_api_id
      t.integer    :minimum_application_quantity
      t.integer    :product_id
      t.string     :country, index: true
      t.datetime   :last_sync

      t.timestamps
    end
  end

  def down
    drop_table :product_customizations
  end
end
