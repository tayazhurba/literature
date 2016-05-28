class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|

      t.belongs_to  :list

      t.integer     :rec_type

      t.string      :record

      t.timestamps
    end
  end
end
