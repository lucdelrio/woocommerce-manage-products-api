# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_15_222758) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string "zecat_product_id"
    t.string "zecat_media_id"
    t.string "woocommerce_api_id"
    t.string "woocommerce_api_product_id"
    t.datetime "woocommerce_last_updated_at"
    t.datetime "last_sync"
    t.json "media_hash"
    t.integer "index"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_attachments_on_product_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "zecat_id"
    t.string "woocommerce_api_id"
    t.datetime "woocommerce_last_updated_at"
    t.datetime "last_sync"
    t.json "category_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_attribute_terms", force: :cascade do |t|
    t.string "name"
    t.string "woocommerce_api_id"
    t.string "woocommerce_api_product_attribute_id"
    t.datetime "woocommerce_last_updated_at"
    t.datetime "last_sync"
    t.json "term_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_attributes", force: :cascade do |t|
    t.string "name"
    t.string "woocommerce_api_id"
    t.datetime "woocommerce_last_updated_at"
    t.datetime "last_sync"
    t.json "attribute_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "zecat_id"
    t.string "woocommerce_api_id"
    t.datetime "woocommerce_last_updated_at"
    t.datetime "last_sync"
    t.json "product_hash"
    t.json "variation_hash"
    t.json "media_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "variations", force: :cascade do |t|
    t.string "zecat_product_id"
    t.string "zecat_variation_id"
    t.string "woocommerce_api_product_id"
    t.string "woocommerce_api_id"
    t.datetime "woocommerce_last_updated_at"
    t.datetime "last_sync"
    t.json "variation_hash"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variations_on_product_id"
  end

  add_foreign_key "attachments", "products"
  add_foreign_key "variations", "products"
end
