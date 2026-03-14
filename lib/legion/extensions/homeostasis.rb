# frozen_string_literal: true

require 'legion/extensions/homeostasis/version'
require 'legion/extensions/homeostasis/helpers/constants'
require 'legion/extensions/homeostasis/helpers/setpoint'
require 'legion/extensions/homeostasis/helpers/regulator'
require 'legion/extensions/homeostasis/helpers/allostatic_load'
require 'legion/extensions/homeostasis/runners/homeostasis'
require 'legion/extensions/homeostasis/client'

module Legion
  module Extensions
    module Homeostasis
      extend Legion::Extensions::Core if Legion::Extensions.const_defined?(:Core)
    end
  end
end
