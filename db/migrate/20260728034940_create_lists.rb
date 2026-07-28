class CreateLists < ActiveRecord::Migration[8.1]
  def change
    create_table :lists, id: :uuid do |t|
      t.string  :title, null: false
      t.text    :description
      t.integer :status, null: false, default: 0
      t.string  :color, null: false, default: "green-lemon"
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :lists, :status
    add_check_constraint :lists, "status IN (0, 1)", name: "lists_status_check"
  end
end
