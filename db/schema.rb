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

ActiveRecord::Schema[7.1].define(version: 2024_10_30_211058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cooking_tips", force: :cascade do |t|
    t.string "tip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cooking_tips_recipes", id: false, force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "cooking_tip_id", null: false
  end

  create_table "cooking_utensils", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cooking_utensils_recipes", id: false, force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "cooking_utensil_id", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.float "national_price"
    t.boolean "taxable"
    t.boolean "snap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measurements", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "measurement_id", null: false
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["measurement_id"], name: "index_recipe_ingredients_on_measurement_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_instructions", force: :cascade do |t|
    t.string "instruction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "recipe_id", null: false
    t.index ["recipe_id"], name: "index_recipe_instructions_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "recipe_name"
    t.float "total_price"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "role"
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "measurements"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_instructions", "recipes"
end
