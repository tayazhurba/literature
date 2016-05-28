class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|

      t.belongs_to :users
      t.string     :name

      t.timestamps
    end
  end
end
