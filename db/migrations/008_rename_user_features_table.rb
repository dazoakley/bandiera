# frozen_string_literal: true

Sequel.migration do
  change do
    rename_table(:user_features, :feature_users)
  end
end
