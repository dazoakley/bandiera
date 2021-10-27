# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:audit_records) do
      drop_column :params
    end

    db = Bandiera::Db.connect
    db[:audit_records].truncate
  end

  down do
    alter_table(:audit_records) do
      add_column :params, String, text: true
    end
  end
end
