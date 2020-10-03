# regular_polygon.rb - part of Vertices, a TeenyTiny Jam Game
#
# The RegularPolygon class is a sprite that represents a regular polygon;
# it's drawn onto a render_target which is used for display, and will 
# handle all the collision detection you might ask for.

module Vertices

  # A sprite of a programmatically-created regular polygon
  class RegularPolygon

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinMovable
    include Ahnlak::MixinSerializable
    attr_sprite

    # Constructor; needs the bare minimum to form a polygon
    def initialize(args, radius, vertices)

      # Set some colour defaults
      colourable(55 + 200.randomize(:ratio), 55 + 200.randomize(:ratio), 55 + 200.randomize(:ratio), 255, 0)

      # Set our dimensions, based on the radius of the polygon
      @source_x = @source_y = 0
      @w = @h = @source_w = @source_h = radius * 2
      @path = "polygon#{object_id}"

      # Place us somewhere sensible
      movable_location((args.grid.w - @w).randomize(:ratio), (args.grid.h - @h).randomize(:ratio))

      # Create an appropriate render target
      args.render_target(@path).borders << { x: 0, y: 0, w: @w, h: @h, r: @r, g: @g, b: @b, a: 255 }
      puts self

    end

    # Central update, that works through all the mixin updates
    def update
      colourable_update
      movable_update
    end

  end

end

# End of regular_polygon.rb
