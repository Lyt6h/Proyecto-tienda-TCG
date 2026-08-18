class CreateSupportMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :support_messages do |t|
      t.string :name
      t.string :email
      t.text :message
      t.boolean :resolved, default: false

      t.timestamps
    end
  end
end
