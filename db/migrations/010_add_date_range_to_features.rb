# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:features) do
      add_column :start_time, Time
      add_column :end_time, Time
    end
  end
end
