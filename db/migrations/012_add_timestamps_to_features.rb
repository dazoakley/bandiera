# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:features) do
      add_column :created_at, Time
      add_column :updated_at, Time
    end
  end
end
