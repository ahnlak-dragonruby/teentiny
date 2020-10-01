# mixin_serializable.rb
#
# A mixin from Ahnlak's DRGrabBag
#
# Automatically provide serialize / inspect / to_s functions, exposing all
# instance variables in a hopefully readable form
#
# Usage: include as `include Ahnlak::MixinSerializable`
#

module Ahnlak

  module MixinSerializable

    # The main serialization
    def serialize

      vars = { 'Class' => self.class.name }
      instance_variables.each { |var|
        vars[var] = instance_variable_get(var)
      }
      return vars

    end

    # inspect and to_s just convert the hash to a string
    def inspect
      serialize.to_s
    end
    def to_s
      serialize.to_s
    end

  end

end