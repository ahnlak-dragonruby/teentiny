# tinted_sprite.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is a regular DR sprite, with colourable and moveable mixins added

module Vertices

  # A lightweight wrapper around a DR sprite, adding in some utility mixins
  class TintedSprite

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinMovable
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

    # Central update, that works through all the mixin updates
    def update
      colourable_update
      movable_update
    end

    # Simple contains check; does a given point fall within the sprite bounds?
    def contains?(point)
      contains_xy?(point.x, point.y)
    end

    def contains_xy?(column, row)
      column > @x && column < @x + @w && row > @y && row < @y + @h
    end

  end

end

# End of tinted_sprite.rb
