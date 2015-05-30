class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.string :other_links
      t.string :owner
      t.string :category
      t.string :raised_amount
      t.string :total_amount

      t.timestamps null: false
    end
  end
end
