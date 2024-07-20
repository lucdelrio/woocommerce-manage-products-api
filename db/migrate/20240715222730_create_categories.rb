# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.1]
  def up
    create_table :categories do |t|
      t.string    :name
      t.text      :description
      t.string    :zecat_id
      t.string    :woocommerce_api_id
      t.datetime  :woocommerce_last_updated_at
      t.datetime  :last_sync
      t.json      :category_hash

      t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
