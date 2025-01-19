class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :blog_type
      t.string :title
      t.string :summary
      t.string :body
      t.string :image
      t.string :slug
      t.json :data, default: {}
      t.datetime :published_at
      t.datetime :discarded_at

      t.index :slug
      t.timestamps
      t.index :discarded_at
    end
  end
end
