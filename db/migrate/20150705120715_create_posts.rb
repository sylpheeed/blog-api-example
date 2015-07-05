class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :title
      t.text :preview
      t.text :text
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
