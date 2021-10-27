# frozen_string_literal: true

Sequel.migration do
  change do
    drop_table(:feature_users)
  end
end
