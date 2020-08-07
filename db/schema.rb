# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_08_190321) do

  create_table "empires", force: :cascade do |t|
    t.string "name"
    t.integer "cash"
    t.integer "metals"
    t.integer "energy"
    t.integer "air_units"
    t.integer "ground_units"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_empires_on_user_id"
  end

  create_table "planets", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.integer "size"
    t.integer "population"
    t.integer "living_quarters"
    t.integer "mines"
    t.integer "power_plants"
    t.integer "empire_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["empire_id"], name: "index_planets_on_empire_id"
    t.index ["x", "y"], name: "index_planets_on_x_and_y", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "empires", "users"
  add_foreign_key "planets", "empires"
end
