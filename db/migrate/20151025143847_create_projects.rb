class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, unique: true, index: true
      t.integer :font_size, null: false
      t.integer :random_num, null: false
      t.integer :max_width, null: false
      t.integer :offset_x, default: 0
      t.integer :offset_y, default: 0

      t.timestamps null: false
    end
  end
end
