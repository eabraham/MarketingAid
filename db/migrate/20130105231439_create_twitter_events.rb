class CreateTwitterEvents < ActiveRecord::Migration
  def change
    create_table :twitter_events do |t|
      t.datetime :send_datetime
      t.integer :token_id
      t.string :tweet

      t.timestamps
    end
  end
end
