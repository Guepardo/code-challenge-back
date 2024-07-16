class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, null: false do |t|
      t.string :username, limit: 255, null: false
      t.string :profile_url, limit: 2048, null: false
      t.string :avatar_url, limit: 2048, null: false
      t.integer :fallowers_count, default: 0, null: false
      t.integer :fallowing_count, default: 0, null: false
      t.integer :stars_count, default: 0, null: false
      t.integer :year_contributions_count, default: 0, null: false
      t.string :location, limit: 255
      t.string :organization_name, limit: 255

      t.timestamps
    end

    add_index :profiles, :username, unique: true
    add_index :profiles, :profile_url, unique: true
  end
end
