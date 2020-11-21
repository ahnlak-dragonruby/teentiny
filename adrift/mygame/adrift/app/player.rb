# player.rb - part of adrift, a TeenyTiny Jam Game
#
# This defines the Player class, which is a self-rendering sprite, with the
# awareness of speed, direction, location and animation. 

module Adrift

  class Player

    # Make it serializable
    include Ahnlak::MixinSerializable

    # And set the attributes
    attr_writer :args
    attr_sprite

    # Constructor, where we load up what we'll need
    def initialize(args)

      # Remember our args reference
      @args = args

      # Our default location will be in the middle of the screen
      @x = @args.grid.center_x
      @y = @args.grid.center_y

      # Set up our base parameters
      @turn_speed = 4
      @thrust = 5
      @vector_x = 0
      @vector_y = 0

      # The size is set to the basic size of the player ship.
      @w = 64
      @h = 64
      @angle = 180
      @target_angle = 0

    end


    # Angle setter; although the angle can be set, this just a target because
    # there is only so fast the ship can turn...
    def angle=(target)

      @target_angle = target.to_i

    end


    # Apply a thrust from the engines; this involves adding a new vector,
    # and activating an appropriate noise and graphic for the engine too
    def thrust(force=-1)

      # If a force was supplied, use that
      @thrust = force if force.positive?

      # Work out our current velocity
      velocity = @vector_x ** 2 + @vector_y ** 2

      # So, apply the current thrust in the direction we're facing
      until (@vector_x ** 2 + @vector_y ** 2) > velocity
        @vector_x += @angle.vector_x(@thrust)
        @vector_y += @angle.vector_y(@thrust)
      end

      # And increase the thrust power :-)
      @thrust *= 1.1

    end


    # Update the location of the player, based on current vector
    def update

      # First up, if we're not yet aligned with the target angle, turn toward it
      if @angle != @target_angle

        # So, should be turning clockwise, or anti?
        gap = @target_angle - @angle
        gap -= 360 if gap > 180
        gap += 360 if gap < -180

        if gap.abs > @turn_speed
          @angle += gap.positive? ? @turn_speed : @turn_speed * -1
        else
          @angle += gap
        end

      end

      # And then add in our current vector
      @x += @vector_x
      @y += @vector_y

    end


    # We implement draw_override so we can compound jets and suchlike in a
    # more controlled way
    def draw_override(ffi_draw)

      # FROM source.txt - this should be documented somewhere :)
      # The argument order for ffi_draw.draw_sprite_3 is:
      # x, y, w, h,
      # path,
      # angle,
      # alpha, red_saturation, green_saturation, blue_saturation
      # flip_horizontally, flip_vertically,
      # tile_x, tile_y, tile_w, tile_h
      # angle_anchor_x, angle_anchor_y,
      # source_x, source_y, source_w, source_h

      # For now, just drop in the player ship, centered on the ship
      ffi_draw.draw_sprite_3(
        @x - (@w / 2), @y - (@h / 2), @w, @h,
        'adrift/sprites/player-ship.png',
        @angle,
        255, nil, nil, nil,
        nil, nil,
        nil, nil, nil, nil,
        0.5, 0.5,
        nil, nil, nil, nil
      )

    end

  end

end

# End of file player.rb
