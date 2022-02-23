class CreateFieldChangeHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :field_change_histories do |t|
      t.references(:source, polymorphic: true, index: true )
      t.string :field_name
      t.string :value

      t.timestamps
    end
  end
end
