class AddDefaultToSecretChoiceDeepInDetails < ActiveRecord::Migration[6.1]
  def change
    change_column :details, :secret_choice_deep, :boolean, default: false
  end
end
