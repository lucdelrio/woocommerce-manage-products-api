# frozen_string_literal: true

class CreateVariations < ActiveRecord::Migration[7.1]
  def up
    # Ver qué product_id usar, si el de Woocommerce o el de Zecat

    create_table :variations do |t|
      t.string      :zecat_product_id
      t.string      :zecat_variation_id
      t.string      :woocommerce_api_product_id
      t.string      :woocommerce_api_id
      t.datetime    :woocommerce_last_updated_at
      t.datetime    :last_sync
      t.json        :variation_hash
      t.references  :product, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :variations
  end
end
