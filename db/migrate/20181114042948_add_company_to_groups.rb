class AddCompanyToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :company, foreign_key: true
  end
end
