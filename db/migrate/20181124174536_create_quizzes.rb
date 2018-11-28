class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.text :title
      t.references :user, foreing_key: true
      t.references :evaluator
      t.references :evaluated
      t.integer :proactivity
      t.integer :organization
      t.integer :flexibility
      t.integer :efficiency
      t.integer :team_work

      t.timestamps
    end
  end
end
