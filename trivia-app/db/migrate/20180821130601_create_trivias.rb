class CreateTrivias < ActiveRecord::Migration[5.2]
  def change
    create_table :trivias do |t|
      t.string :question
      t.string :difficulty
      t.integer :category_id
      t.timestamps
    end
  end
end
