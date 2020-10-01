# tinted_sprite.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is a regular DR sprite, with colourable and moveable mixins added

module Vertices

  class TintedSprite

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinSerializable
    attr_sprite


    # Constructor; takes the usual sprite hash
    def initialize(**params)

      # Set some colour defaults
      colourable( 255, 255, 255, 255, 0 )

      # Store the parameters we find in our ivars
      params.each { |key, value|
        instance_variable_set(key.to_s.prepend('@'), value)
      }

    end

    # Location can either be set absolutely, or as a destination
    def set_location(x, y)
      @x = x
      @y = y
    end

    def set_destination(x, y, speed)
    end



  end

end

# End of tinted_sprite.rb