

# frozen_string_literal: true

class CreateProductAttributeTerms < ActiveRecord::Migration[7.1]
  def up
    create_table :product_attribute_terms do |t|
      t.string     :name
      t.string    :country
      t.integer     :woocommerce_api_id
      t.integer     :woocommerce_api_product_attribute_id
      t.datetime   :woocommerce_last_updated_at
      t.datetime   :last_sync
      t.json       :term_hash

      t.timestamps
    end
  end

  def down
    drop_table :product_attribute_terms
  end
end
