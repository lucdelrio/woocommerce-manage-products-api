# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration[7.1]
  def up
    create_table :attachments do |t|
      t.integer     :zecat_product_id
      t.string    :country
      t.integer     :woocommerce_api_product_id
      t.datetime   :woocommerce_last_updated_at
      t.datetime   :last_sync
      t.json       :media_hash

      t.timestamps
    end
  end

  def down
    drop_table :attachments
  end
end
