class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.belongs_to :list
      t.timestamps
    end
  end
end
