# frozen_string_literal: true

class CreateVariations < ActiveRecord::Migration[7.1]
  def up
    # Ver qué product_id usar, si el de Woocommerce o el de Zecat

    create_table :variations do |t|
      t.json        :variation_hash
      t.float       :regular_price
      t.integer      :zecat_product_id
      t.integer      :zecat_variation_id
      t.integer      :woocommerce_api_product_id
      t.integer      :woocommerce_api_id
      t.datetime    :woocommerce_last_updated_at
      t.datetime    :last_sync
      
      t.timestamps
    end
  end

  def down
    drop_table :variations
  end
end
