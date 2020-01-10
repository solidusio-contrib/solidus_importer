# frozen_string_literal: true

require 'solidus_core'

require 'solidus_importer/exception'
require 'solidus_importer/utils'

require 'solidus_importer/importers/base'
importers = File.join(__dir__, 'solidus_importer/importers/*.rb')
Dir[importers].each { |file| require file }

require 'solidus_importer/processors/base'
processors = File.join(__dir__, 'solidus_importer/processors/*.rb')
Dir[processors].each { |file| require file }

require 'solidus_importer/configuration'
require 'solidus_importer/engine'
require 'solidus_importer/process_import'
require 'solidus_importer/process_row'
