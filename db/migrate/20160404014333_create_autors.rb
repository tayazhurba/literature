class CreateAutors < ActiveRecord::Migration
  def change
    create_table :autors do |t|

      t.integer :source_id
      t.string  :author_sur
      t.string  :author_name
      t.string  :author_last

      t.timestamps
    end
  end
end
