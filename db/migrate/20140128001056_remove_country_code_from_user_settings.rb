class RemoveCountryCodeFromUserSettings < ActiveRecord::Migration
  def change
    remove_column :user_settings, :country_code, :string
  end
end
