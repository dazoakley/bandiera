# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:audit_records) do
      add_column :object_id, Integer
    end
  end
end
