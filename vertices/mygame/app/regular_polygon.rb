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
    attr_accessor :args

    # Constructor; needs the bare minimum to form a polygon
    def initialize(args, radius, vertices)

      # Remember the args
      @args = args

      # Set some colour defaults
      colourable(55 + 200.randomize(:ratio), 155 + 100.randomize(:ratio), 55 + 200.randomize(:ratio), 255, 0)

      # Set our dimensions, based on the radius of the polygon
      @source_x = @source_y = @angle = 0
      @w = @h = @source_w = @source_h = radius * 2
      @path = "polygon#{object_id}"

      # Place us somewhere sensible
      movable_location((args.grid.w - @w).randomize(:ratio), (args.grid.h - @h - 10).randomize(:ratio))

      # With an arbitray spin
      movable_spin((30 + 60.randomize(:ratio)).randomize(:sign))

      # Create an appropriate render target
      args.render_target(@path).borders << { x: 0, y: 0, w: @w, h: @h, r: @r, g: @g, b: @b, a: 255 }
      args.render_target(@path).labels << { x: 2, y: 20, r: @r, g: @g, b: @b, a: 255, text: vertices.to_s }

    end

    # Central update, that works through all the mixin updates
    def update

      # Run through the mixin updates
      colourable_update
      movable_update

      # If we've reached the end of our last movement, pick a new destination
      unless movable_moving?

        # Pick a side to move to
        speed = 75 + 30.randomize(:ratio)
        case 4.randomize(:ratio).to_i
        when 0
          movable_location(0, (args.grid.h - @h - 10).randomize(:ratio), speed)
        when 1
          movable_location((args.grid.w - @w).randomize(:ratio), 0, speed)
        when 2
          movable_location((args.grid.w - @w), (args.grid.h - @h - 10).randomize(:ratio), speed)
        when 3
          movable_location((args.grid.w - @w).randomize(:ratio), (args.grid.h - @h - 10), speed)
        end

        # And give it a new kick of spin
        movable_spin((30 + 60.randomize(:ratio)).randomize(:sign))

      end

    end

  end

end

# End of regular_polygon.rb
