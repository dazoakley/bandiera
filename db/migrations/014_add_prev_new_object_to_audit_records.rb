Sequel.migration do
  change do
    alter_table(:audit_records) do
      add_column :old_object, String
      add_column :new_object, String
    end
  end
end
