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

ActiveRecord::Schema[7.1].define(version: 2024_11_30_193427) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cooking_tips", force: :cascade do |t|
    t.string "tip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cookware", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.float "national_price"
    t.boolean "taxable"
    t.boolean "snap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kroger_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.index "lower((unit)::text)", name: "index_measurements_on_lower_unit", unique: true
  end

  create_table "recipe_cooking_tips", force: :cascade do |t|
    t.bigint "cooking_tip_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooking_tip_id"], name: "index_recipe_cooking_tips_on_cooking_tip_id"
    t.index ["recipe_id"], name: "index_recipe_cooking_tips_on_recipe_id"
  end

  create_table "recipe_cookwares", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "cookware_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cookware_id"], name: "index_recipe_cookwares_on_cookware_id"
    t.index ["recipe_id"], name: "index_recipe_cookwares_on_recipe_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.bigint "measurement_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["measurement_id"], name: "index_recipe_ingredients_on_measurement_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_instructions", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "cooking_style"
    t.string "instruction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instruction_step"
    t.index ["recipe_id"], name: "index_recipe_instructions_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.float "total_price"
    t.string "image"
    t.integer "serving_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "role", default: 1
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "username"
    t.index ["key"], name: "index_users_on_key", unique: true
  end

  add_foreign_key "recipe_cooking_tips", "cooking_tips"
  add_foreign_key "recipe_cooking_tips", "recipes"
  add_foreign_key "recipe_cookwares", "cookware"
  add_foreign_key "recipe_cookwares", "recipes"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "measurements"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_instructions", "recipes"
end
