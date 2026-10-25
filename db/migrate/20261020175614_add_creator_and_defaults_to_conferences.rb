class AddCreatorAndDefaultsToConferences < ActiveRecord::Migration[8.1]
  def change
    add_reference :conferences, :creator, null: true, foreign_key: { to_table: :users }
    change_column_default :conferences, :is_scopus, from: nil, to: false
    change_column_default :conferences, :is_elibrary, from: nil, to: false

    reversible do |dir|
      dir.up { execute "UPDATE conferences SET status = 1 WHERE status IS NULL" }
    end
    change_column_default :conferences, :status, from: nil, to: 1

    add_index :bookmarks, [ :user_id, :conference_id ], unique: true
  end
end
