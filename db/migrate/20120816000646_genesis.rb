class Genesis < ActiveRecord::Migration
  def up
    create_table :users, id: false do |t|
      t.string    :id,               null: false, primary_key: true, limit: 7

      t.timestamps
      t.datetime  :deleted_at

      t.string    :email
      t.string    :first_name
      t.string    :last_name

      # facebook:
      t.string    :fb_uid
      t.string    :fb_access_token
      
      # twitter:
      t.string    :tw_uid
      t.string    :tw_access_token
    end
    add_index :users, :id, unique: true
    add_index :users, :deleted_at
    add_index :users, :email
    add_index :users, :fb_uid
    add_index :users, :tw_uid


    create_table :videos, id: false do |t|
      t.string    :id,               null: false, primary_key: true, limit: 7

      t.timestamps
      t.datetime  :deleted_at
      
      t.string    :host_url, limit: 2048, null: false
      t.string    :title,    limit: 1024
      t.text      :description
      t.text      :html
      t.integer   :width
      t.integer   :height
      t.string    :thumbnail_url, limit: 1024
    end
    add_index :videos, :id, unique: true
    add_index :videos, :deleted_at
    add_index :videos, :host_url, unique: true


    create_table :bookmarks, id: false do |t|
      t.string    :id,               null: false, primary_key: true, limit: 7

      t.timestamps
      t.datetime  :deleted_at
      
      t.string :user_id
      t.string :video_id
    end
    add_index :bookmarks, :id, unique: true
    add_index :bookmarks, :deleted_at
    add_index :bookmarks, :user_id
    add_index :bookmarks, :video_id

  end

  def down
    drop_table :bookmarks
    drop_table :videos
    drop_table :users
  end
end
