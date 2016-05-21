class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|

      t.belongs_to  :user

      t.integer     :rec_type
      
      t.timestamps
    end
  end
end
