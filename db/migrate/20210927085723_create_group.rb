class CreateGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.text :name
      t.text :page_url
      t.timestamps
    end
  end
end
