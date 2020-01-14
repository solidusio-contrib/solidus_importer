# frozen_string_literal: true

module SolidusImporter
  module Utils
    def extract_attrs(row_data, row_mapping)
      row_mapping.each_with_object({}) do |(src, dst), attrs|
        value = row_data[src]
        attrs[dst] = value if dst && !value.nil?
      end
    end
  end
end
