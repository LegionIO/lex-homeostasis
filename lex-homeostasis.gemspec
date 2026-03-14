# frozen_string_literal: true

require_relative 'lib/legion/extensions/homeostasis/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-homeostasis'
  spec.version       = Legion::Extensions::Homeostasis::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Homeostasis'
  spec.description   = 'Cognitive self-regulation with setpoints, negative feedback loops, and allostatic load tracking'
  spec.homepage      = 'https://github.com/LegionIO/lex-homeostasis'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/LegionIO/lex-homeostasis'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-homeostasis'
  spec.metadata['changelog_uri'] = 'https://github.com/LegionIO/lex-homeostasis'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/LegionIO/lex-homeostasis/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-homeostasis.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
end
