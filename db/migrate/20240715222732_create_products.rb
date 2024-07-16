class CreateProducts < ActiveRecord::Migration[7.1]
  def up
    create_table :products do |t|
      t.string    :name
      t.text      :description
      t.string    :zecat_id
      t.string    :woocommerce_api_id
      t.datetime  :woocommerce_last_updated_at
      t.datetime  :last_sync
      t.json      :product_hash
      t.json      :variation_hash
      t.json      :media_hash
      
      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end
