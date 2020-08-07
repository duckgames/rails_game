class CreateEmpires < ActiveRecord::Migration[6.0]
  def change
    create_table :empires do |t|
      t.string :name
      t.integer :cash, :default => 0
      t.integer :metals, :default => 0
      t.integer :energy, :default => 0
      t.integer :air_units, :default => 0
      t.integer :ground_units, :default => 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
