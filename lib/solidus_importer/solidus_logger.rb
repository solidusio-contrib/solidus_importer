# frozen_string_literal: true

module SolidusImporter
  class SolidusLogger
    def log_entry(log)
      Spree::LogEntry.create!(
        source: log.source,
        details: log.context.except(:importer, :data).to_json
      )
    end

    alias :debug :log_entry
    alias :error :log_entry
    alias :fatal :log_entry
    alias :info :log_entry
    alias :unknown :log_entry
    alias :warn :log_entry
  end
end
