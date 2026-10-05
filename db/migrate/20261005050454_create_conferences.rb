class CreateConferences < ActiveRecord::Migration[8.1]
  def change
    create_table :conferences do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.date :submission_deadline
      t.string :location
      t.string :website_url
      t.boolean :is_scopus
      t.boolean :is_elibrary
      t.integer :status

      t.timestamps
    end
  end
end
