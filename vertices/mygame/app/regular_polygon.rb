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
    attr_reader :vertices

    # Constructor; needs the bare minimum to form a polygon
    def initialize(args, radius, vertices)

      # Remember the args
      @args = args
      @radius = radius
      @vertices = vertices

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
      # args.render_target(@path).borders << { x: 0, y: 0, w: @w, h: @h, r: @r, g: @g, b: @b, a: 255 }
      args.render_target(@path).labels << {
        x: radius * 1.1, y: radius * 1.3,
        r: @r, g: @g, b: @b, a: 255,
        font: 'fonts/Kenney Future Square.ttf',
        size_enum: 10, alignment_enum: 1, text: vertices.to_s
      }

      # Draw the polygon, in a hopefully nice way
      20.times do |x|
        args.render_target(@path).lines << polygon_draw(vertices, radius, radius, radius - x, x * 8)
      end
      args.render_target(@path).lines << polygon_draw(vertices, radius, radius, radius, -255)

    end


    # Method to draw a polygon with a specified center and radius; returns
    # an array of lines
    def polygon_draw(vertices, center_x, center_y, radius, tone)

      # So, this will all go back in a big array
      lines = []

      # Draw the shape; start with the first vertex at 12 o'clock
      vertex_x = last_x = center_x
      vertex_y = last_y = center_y + radius
      vertex_angle = 360 / vertices

      # And then work through all the sides
      (1..vertices).each do |vertex|

        # Calculate the next point
        next_x = center_x + (vertex_x - center_x) * Math.cos((vertex_angle * vertex).to_radians) -
                 (vertex_y - center_y) * Math.sin((vertex_angle * vertex).to_radians)
        next_y = center_y + (vertex_x - center_x) * Math.sin((vertex_angle * vertex).to_radians) +
                 (vertex_y - center_y) * Math.cos((vertex_angle * vertex).to_radians)

        # And draw a line to the next vertex
        lines << { x: last_x, y: last_y, x2: next_x, y2: next_y, r: @r - tone, g: @g - tone, b: @b - tone, a: @a }

        # Lastly, remember the last point
        last_x = next_x
        last_y = next_y

      end

      # Finally, close the loop
      lines << { x: vertex_x, y: vertex_y, x2: last_x, y2: last_y, r: @r - tone, g: @g - tone, b: @b - tone, a: @a }
      lines

    end


    # Function to see if we've been clicked
    def contains(point)

      # For now, we'll just do a circle check within our radius - a circle
      # definitely contains our polygon, and this just gives the user a bit
      # of flex, too
      (point.x - (@x + @radius))**2 + (point.y - (@y + @radius))**2 < @radius**2

    end


    # Central update, that works through all the mixin updates
    def update

      # Run through the mixin updates
      colourable_update
      movable_update

      # All done if we're still moving
      return if movable_moving?

      # We've reached the end of our last movement, so pick a new destination

      # Pick a side to move to
      speed = 60 + 40.randomize(:ratio)
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
      movable_spin((50 + 30.randomize(:ratio)).randomize(:sign))

    end

  end

end

# End of regular_polygon.rb
