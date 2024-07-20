# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration[7.1]
  def up
    create_table :attachments do |t|
      t.string     :zecat_product_id
      t.string     :zecat_media_id
      t.string     :woocommerce_api_id
      t.string     :woocommerce_api_product_id
      t.datetime   :woocommerce_last_updated_at
      t.datetime   :last_sync
      t.json       :media_hash
      t.integer    :index
      # sacar index
      t.references :product, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :attachments
  end
end
