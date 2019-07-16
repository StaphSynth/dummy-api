class AddUserToken < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :auth_token_digest, :string
    add_index :users, :auth_token_digest
  end
end
