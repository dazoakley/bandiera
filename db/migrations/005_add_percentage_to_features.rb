# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:features) do
      add_column :percentage, Integer
    end
  end
end
