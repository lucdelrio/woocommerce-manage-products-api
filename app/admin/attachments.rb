# rubocop:disable BlockLength
ActiveAdmin.register Attachment do
  index do
    column :zecat_product_id
    column :woocommerce_api_id
    column :woocommerce_api_product_id
    column :woocommerce_last_updated_at
    column :last_sync
    column :created_at
    
    actions
  end

  filter :zecat_product_id
  filter :woocommerce_api_id
  filter :woocommerce_api_product_id

  show do |_s|
    attributes_table do
      row :zecat_product_id
      row :woocommerce_api_id
      row :woocommerce_api_product_id
      row :media_hash
      row :woocommerce_last_updated_at
      row :last_sync
      row :created_at
    end
  end

  # form do |f|
  #   f.inputs 'Edit account' do
  #     f.input :name
  #     f.input :description
  #   end
  #   f.actions
  # end

  # controller do
  #   def permitted_params
  #     params.permit!
  #   end
  # end
end
# rubocop:enable BlockLength

# create_table "attachments", force: :cascade do |t|
#   t.string "zecat_product_id"
#   t.string "zecat_media_id"
#   t.string "woocommerce_api_id"
#   t.string "woocommerce_api_product_id"
#   t.datetime "woocommerce_last_updated_at"
#   t.datetime "last_sync"
#   t.json "media_hash"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end

# create_table "categories", force: :cascade do |t|
#   t.string "name"
#   t.text "description"
#   t.string "zecat_id"
#   t.string "woocommerce_api_id"
#   t.datetime "woocommerce_last_updated_at"
#   t.datetime "last_sync"
#   t.json "category_hash"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end

# create_table "product_attribute_terms", force: :cascade do |t|
#   t.string "name"
#   t.string "woocommerce_api_id"
#   t.string "woocommerce_api_product_attribute_id"
#   t.datetime "woocommerce_last_updated_at"
#   t.datetime "last_sync"
#   t.json "term_hash"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end

# create_table "product_attributes", force: :cascade do |t|
#   t.string "name"
#   t.string "woocommerce_api_id"
#   t.datetime "woocommerce_last_updated_at"
#   t.datetime "last_sync"
#   t.json "attribute_hash"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end

# create_table "products", force: :cascade do |t|
#   t.string "name"
#   t.text "description"
#   t.string "zecat_id"
#   t.string "woocommerce_api_id"
#   t.datetime "woocommerce_last_updated_at"
#   t.datetime "last_sync"
#   t.json "product_hash"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.jsonb "zecat_hash"
#   t.float "regular_price"
# end

# create_table "variations", force: :cascade do |t|
#   t.string "zecat_product_id"
#   t.string "zecat_variation_id"
#   t.string "woocommerce_api_product_id"
#   t.string "woocommerce_api_id"
#   t.datetime "woocommerce_last_updated_at"
#   t.datetime "last_sync"
#   t.json "variation_hash"
#   t.bigint "product_id"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.float "regular_price"
#   t.index ["product_id"], name: "index_variations_on_product_id"
# end