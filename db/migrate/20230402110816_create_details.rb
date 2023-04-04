class CreateDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :details do |t|
      t.text :public
      t.text :secret
      t.text :deeply
      t.boolean :secret_choice_deep
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
