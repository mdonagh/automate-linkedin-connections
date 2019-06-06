class CreateUsedLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :used_links do |t|
      t.string :href
      t.timestamps
    end
  end
end
