# frozen_string_literal: true

class CreateProductAttributes < ActiveRecord::Migration[7.1]
  def up
    create_table :product_attributes do |t|
      t.string     :name
      t.string     :country, index: true
      t.integer    :woocommerce_api_id
      t.datetime   :woocommerce_last_updated_at
      t.datetime   :last_sync
      t.json       :attribute_hash

      t.timestamps
    end
  end

  def down
    drop_table :product_attributes
  end
end
