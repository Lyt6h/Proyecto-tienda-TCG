class ChangeReportedDefaultInReviews < ActiveRecord::Migration[8.1]
  def change
    change_column_default :reviews, :reported, from: nil, to: false
    change_column_null :reviews, :reported, false, false
  end
end
