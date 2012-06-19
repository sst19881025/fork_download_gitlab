class CreateForks < ActiveRecord::Migration
  def change
    create_table :forks do |t|
      t.integer :user_id
      t.references :project

      t.timestamps
    end
    add_index :forks, :project_id
  end
end
