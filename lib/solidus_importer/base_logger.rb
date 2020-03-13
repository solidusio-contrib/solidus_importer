# frozen_string_literal: true

module SolidusImporter
  class BaseLogger
    delegate :debug, :error, :fatal, :info, :unknown, :warn, to: :logger_engine

    def logger_engine
      @logger_engine ||= Logger.new(STDOUT)
    end
  end
end
