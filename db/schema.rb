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

ActiveRecord::Schema.define(version: 2023_05_17_094959) do

  create_table "bands", force: :cascade do |t|
    t.string "name"
    t.float "freq"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "datasets", force: :cascade do |t|
    t.string "image"
    t.string "uvf"
    t.float "rms"
    t.float "lowest_contour"
    t.float "peak_flux"
    t.float "beam_maj"
    t.float "beam_min"
    t.float "beam_pos"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "publications", force: :cascade do |t|
    t.text "authors"
    t.string "title"
    t.string "reference"
    t.string "ads_link"
    t.string "arxiv_link"
    t.string "pdf_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.date "data"
    t.text "comment"
    t.string "obs_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "be1950name"
    t.string "alt_name"
    t.string "ra"
    t.string "decl"
    t.text "comment"
    t.string "atca_link"
    t.string "source_type"
    t.float "redshift"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
