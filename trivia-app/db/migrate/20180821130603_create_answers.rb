class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.string :answer
      t.boolean :is_correct
      t.integer :trivium_id
      t.timestamps
    end
  end
end
