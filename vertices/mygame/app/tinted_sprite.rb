# tinted_sprite.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is a regular DR sprite, with colourable and moveable mixins added

module Vertices

  # A lightweight wrapper around a DR sprite, adding in some utility mixins
  class TintedSprite

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinSerializable
    attr_sprite


    # Constructor; takes the usual sprite hash
    def initialize(**params)

      # Set some colour defaults
      colourable(255, 255, 255, 255, 0)

      # Store the parameters we find in our ivars
      params.each do |key, value|
        instance_variable_set(key.to_s.prepend('@'), value)
      end

    end

    # Location can either be set absolutely, or as a destination
    def set_location(xxx, yyy)
      @x = xxx
      @y = yyy
    end

    def set_destination(xxx, _yyy, _speed)
      @x = xxx
    end



  end

end

# End of tinted_sprite.rb
