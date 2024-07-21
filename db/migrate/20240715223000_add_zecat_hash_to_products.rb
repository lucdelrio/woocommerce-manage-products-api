

# frozen_string_literal: true

class AddZecatHashToProducts < ActiveRecord::Migration[7.1]
  def up
    add_column    :products, :zecat_hash,     :string
    remove_column :products, :media_hash  
    remove_column :products, :variation_hash
  end

  def down
    remove_column :products, :zecat_hash
    add_column    :products, :media_hash,      :json
    add_column    :products, :variation_hash,  :json
  end
end
