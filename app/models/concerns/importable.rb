module Importable
  extend ActiveSupport::Concern

  module ClassMethods

    def import_csv(file)
      PaperTrail.enabled = false
      CSV.foreach(file.path, headers: true) do |row|
        record = new(row.to_hash, without_protection: true)
        record.save!(validate: false)
      end
      ActiveRecord::Base.connection.execute("SELECT setval('#{table_name}_id_seq', (SELECT MAX(id) FROM #{table_name}));")
      PaperTrail.enabled = true
    end
  end
end
