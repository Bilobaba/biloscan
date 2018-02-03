class CreateUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :urls do |t|
      t.string :path
      t.text :text_bilobaba
      t.datetime :date_bilobaba
      t.text :last_scan_text
      t.datetime :last_scan_date
      t.text :text_diff
      t.text :text_diff_html
      t.text :text_diff_html_left
      t.text :text_diff_html_right

      t.timestamps
    end
  end
end
