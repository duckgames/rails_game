class CreatePlanets < ActiveRecord::Migration[6.0]
  def change
    create_table :planets do |t|
      t.integer :x
      t.integer :y
      t.integer :size, :default => 0
      t.integer :population, :default => 0
      t.integer :living_quarters, :default => 0
      t.integer :mines, :default => 0
      t.integer :power_plants, :default => 0
      t.references :empire, null: true, foreign_key: true
      
      t.timestamps
    end
    
    add_index :planets, [:x, :y], unique: true
  end
end
