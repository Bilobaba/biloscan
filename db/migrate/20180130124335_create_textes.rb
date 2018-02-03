class CreateTextes < ActiveRecord::Migration[5.1]
  def change
    create_table :textes do |t|
      t.text :texte
      t.string :chaine

      t.timestamps
    end
  end
end
