class CreateUserImports < ActiveRecord::Migration[8.0]
  def change
    create_table :user_imports do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0
      t.integer :total_rows, null: false, default: 0
      t.integer :processed_rows, null: false, default: 0
      t.integer :failed_rows, null: false, default: 0
      t.jsonb :error_details, null: false, default: []
      t.timestamps
    end
    add_index :user_imports, :status
  end
end
