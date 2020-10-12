# counter.rb - part of Vertices, a TeenyTiny Jam Game
#
# The Counter class is a sprite which shows a growing, fading number in the
# centre f the screen - it's done as a sprite so that we can scale it
# arbitrarily because labels seem to have a hard and silent limit.

module Vertices

  # A sprite of a number, pretty much
  class Counter

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinMovable
    include Ahnlak::MixinSerializable
    attr_sprite
    attr_accessor :args

    # Constructor; only really needs access to the args
    def initialize(args)

      # Remember the args
      @args = args

      # Set some colour defaults
      colourable(255, 0, 0, 0)

      # And some default sizes and positions
      @w = @h = @source_w = @source_h = 128
      @source_x = @source_y = @angle = 0
      @path = "counter#{object_id}"
      @count = 0

      # Place us somewhere sensible
      movable_location(args.grid.center_x - @w / 2, (args.grid.h - @h) / 2)

      # Create an appropriate render target
      args.render_target(@path).borders << { x: 0, y: 0, w: @w, h: @h, r: @r, g: @g, b: @b, a: 255 }

    end

    # Central update, that works through all the mixin updates
    def update

      # Run through the mixin updates
      colourable_update
      movable_update

    end

    # Counter set; this triggers the resize/move/fade cycle
    def count=(value)

      # So, set the count to the new value
      @count = value

      # Update the text
      args.render_target(@path).labels << {
        x: 10, y: 128,
        r: 255, g: 255, b: 255, a: 255,
        font: 'fonts/Kenney Future Square.ttf',
        size_enum: 50, text: @count.to_s
      }

      # Set the position back to the start, and set it drifting up
      movable_location(@args.grid.center_x, @args.grid.center_y - 250)
      movable_location(@args.grid.center_x - 175, @args.grid.center_y + 250, 60)
      movable_size(128, 128)
      movable_size(768, 768, 60)

      # At the same time, set the colour red and fade
      colourable(255, 0, 0, 255)
      colourable(0, 0, 0, 0, 60)

    end

    # Visibility flag, to control when we draw
    def visible?
      @a.nonzero?
    end

  end

end

# End of counter.rb
