# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:features) do
      rename_column :enabled, :active
    end
  end
end
