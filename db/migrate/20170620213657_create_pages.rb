class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.text :parsed
      t.text :url
      t.string :chksum

      t.timestamps
    end
  end
end
