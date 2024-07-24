# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def up
    create_table :products do |t|
      t.string    :name
      t.text      :description
      t.float     :regular_price
      t.integer    :zecat_id
      t.integer    :woocommerce_api_id
      t.datetime  :woocommerce_last_updated_at
      t.datetime  :last_sync
      t.json      :product_hash
      t.jsonb      :zecat_hash

      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end
