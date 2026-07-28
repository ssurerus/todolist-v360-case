class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items, id: :uuid do |t|
      t.string   :title, null: false
      t.text     :description
      t.integer  :status, null: false, default: 0
      t.datetime :due_at
      t.references :list, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :items, :status
    add_index :items, [ :list_id, :status ]
    add_check_constraint :items, "status IN (0, 1, 2)", name: "items_status_check"
  end
end
