class RemoveAddressBuildingFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :address_building, :string
  end
end
