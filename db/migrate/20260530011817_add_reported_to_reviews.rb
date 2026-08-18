class AddReportedToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :reported, :boolean
  end
end
