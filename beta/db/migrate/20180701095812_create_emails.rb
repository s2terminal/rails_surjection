class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.references :user, foreign_key: true
      t.string :adress

      t.timestamps
    end
  end
end
