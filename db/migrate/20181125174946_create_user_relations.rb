class CreateUserRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_relations do |t|
      t.references :user, foreing_key: true
      t.references :user2

      t.timestamps
    end
  end
end
