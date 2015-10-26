class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :eid
      t.string :gid
      t.string :body
      t.references :project

      t.timestamps null: false
    end
  end
end
