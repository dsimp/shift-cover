class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.date :shift_date
      t.references :opener, null: false, foreign_key: { to_table: :users }
      t.references :cover, null: false, foreign_key: { to_table: :users }
      t.string :location_name
      t.datetime :shift_started_at
      t.datetime :shift_ended_at
      t.string :location_address
      t.string :title
      t.text :description
      t.references :job_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
