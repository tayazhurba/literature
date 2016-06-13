class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.belongs_to :record
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
