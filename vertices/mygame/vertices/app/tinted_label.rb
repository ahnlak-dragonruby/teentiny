# tinted_label.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is a regular DR label, with colourable and moveable mixins added

module Vertices

  # A lightweight wrapper around a DR label, adding in some utility mixins
  class TintedLabel

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinMovable
    include Ahnlak::MixinSerializable

    attr_reader :visible

    # One day, this should be wrapped in attr_label...
    attr_reader :x, :y
    attr_accessor :text, :size_enum, :alignment_enum, :font, :r, :g, :b, :a
    def primitive_marker
      :label
    end

    # Constructor; takes the usual sprite hash
    def initialize(**params)

      # Set some colour defaults
      colourable(255, 255, 255, 255, 0)

      # Store the parameters we find in our ivars
      params.each do |key, value|
        instance_variable_set(key.to_s.prepend('@'), value)
      end

      # Make sure to set x and y appropriate for visiblity
      self.x = @x
      self.y = @y

    end

    # The visible value needs to be a bit clever
    def visible=(flag)

      # Save the flag, obviously
      @visible = flag

      # If we're going invisible, move off the screen
      unless flag
        @x = $gtk.args.grid.w + @x if @x < $gtk.args.grid.w
        @y = $gtk.args.grid.h + @y if @y < $gtk.args.grid.h
        return
      end

      # Then we're becoming visible
      @x -= $gtk.args.grid.w if @x >= $gtk.args.grid.w
      @y -= $gtk.args.grid.h if @y >= $gtk.args.grid.h

    end

    # Similarly, the x and y setters need to be aware of visibility
    def x=(column)
      @x =
        if @visible
          column
        else
          $gtk.args.grid.w + column
        end
    end

    def y=(row)
      @y =
        if @visible
          row
        else
          $gtk.args.grid.h + row
        end
    end

    # Grow the size by a defined amount
    def grow(amount)
      @size_enum += amount
    end

    # Central update, that works through all the mixin updates
    def update
      colourable_update
      movable_update
    end

  end

end

# End of tinted_sprite.rb
