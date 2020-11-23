# player.rb - part of adrift, a TeenyTiny Jam Game
#
# This defines the Player class, which is a self-rendering sprite, with the
# awareness of speed, direction, location and animation. 

module Adrift

  class Player

    THRUST_DURATION=50

    # Make it serializable
    include Ahnlak::MixinSerializable

    # And set the attributes
    attr_writer :args
    attr_reader :fired
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
      @vector_x = 0
      @vector_y = 0
      @delta_v = 0
      @peak_velocity = 0
      @target_velocity = 0
      @fired = false

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

      # If a force was supplied, use that as an absolute
      if force.positive?
        @peak_velocity = force
        @vector_x = 0
        @vector_y = 0
      end

      # So, apply the current thrust in the direction we're facing
      @target_velocity = @peak_velocity * 1.35
      @delta_v = @target_velocity / THRUST_DURATION

      # Set the thrusting counter to cycle through the graphics
      @thrusting = THRUST_DURATION
      @fired = true

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

      # Apply any current thrust
      if @thrusting.positive?

        # The delta modifies the vectors
        @vector_x += @angle.vector_x(@delta_v)
        @vector_y += @angle.vector_y(@delta_v)

        # And count the thrust down
        @thrusting -= 1

      end

      # And then add in our current vector
      @x += @vector_x
      @y += @vector_y

      # We keep on thrusting until we exceed our previous peak
      velocity = Math::sqrt(@vector_x ** 2 + @vector_y ** 2)
      if velocity < @target_velocity && @thrusting.zero?
        @thrusting = THRUST_DURATION
        @fired = true
      end
      @peak_velocity = velocity if velocity > @peak_velocity

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

      # Firstly drop in the player ship, centered on the ship
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

      # If we're thrusting, we add on the plume from the engines...
      if @thrusting.positive?

        # Draw the flame
        ffi_draw.draw_sprite_3(
          @x - 64 - @angle.vector_x(90), 
          @y - 64 - @angle.vector_y(90),
          128, 128, 'adrift/sprites/thrust.png', @angle + 90,
          128, nil, nil, nil,
          nil, nil,
          nil, nil, nil, nil,
          0.5, 0.5,
          (@thrusting / 8).to_i * 128, (@thrusting % 8).to_i * 128,
          128, 128
        )

      end

      # Lastly, clear the firing flag; we know this function happens late
      # in the pipeline so it's a safe place to clear it
      @fired = false

    end

  end

end

# End of file player.rb
