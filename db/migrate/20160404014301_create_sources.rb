class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|

      t.integer :user_id

      t.string  :title
      t.integer :year
      t.string  :publisher
      t.integer :volume
      t.string  :city
      t.integer :edition_number
      t.integer :number
      t.string  :position
      t.string  :article_title
      t.string  :url
      t.date    :release_date
      t.date    :accessing_resource

      t.integer :type_id

      t.timestamps
    end
  end
end
