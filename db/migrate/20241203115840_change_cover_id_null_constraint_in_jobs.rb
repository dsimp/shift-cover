class ChangeCoverIdNullConstraintInJobs < ActiveRecord::Migration[6.1]
  def up
    change_column_null :jobs, :cover_id, true
  end

  def down
    change_column_null :jobs, :cover_id, false
  end
end
