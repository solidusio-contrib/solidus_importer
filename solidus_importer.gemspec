# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_importer/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_importer'
  s.version     = SolidusImporter::VERSION
  s.summary     = 'Solidus Importer'
  s.description = 'Solidus Importer'
  s.license     = 'BSD-3-Clause'

  s.author      = 'Nebulab SRL'
  s.homepage    = 'https://www.nebulab.it'
  # s.email     = 'you@example.com'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'solidus_core' # Set Solidus version

  s.add_development_dependency 'solidus_extension_dev_tools'
end
