# mixin_colourable.rb
#
# A mixin from Ahnlak's DRGrabBag
#
# Adds in r/g/b/a attributes, along with functions to set those channels and
# fade them to new values over time. 
#
# Usage: include as `include Ahnlak::MixinColourable`
#
# rgba values can then be set with colourable / colourable_array
#
# If the speed parameter is included, ensure to call update every tick to
# slowly fade to the specified colour
#

module Ahnlak

  module MixinColourable

    attr_accessor :r, :g, :b, :a


    # Initialise the target and delta hashes, if they're not set yet
    def colourable_init_hashes
      @colourable_target = Hash.new if !@colourable_target
      @colourable_delta = Hash.new if !@colourable_delta
    end


    # Set the channel targets, used to control fades
    def colourable_set_target_array(targets)
      colourable_set_target(targets[0], targets[1], targets[2], targets[3])
    end

    def colourable_set_target(r, g, b, a)
      colourable_init_hashes
      @colourable_target.merge!({r: r, g: g, b: b, a: a})
    end


    # Set the channel delta, used to control fades
    def colourable_set_delta_array(deltas)
      colourable_set_delta(deltas[0], deltas[1], deltas[2], deltas[3])
    end

    def colourable_set_delta(r, g, b, a)
      colourable_init_hashes
      @colourable_delta.merge!({r: r, g: g, b: b, a: a})
    end


    # The main (user-facing) call is to set the colour
    def colourable_array(colour, speed=0)
      colourable(colour[0], colour[1], colour[2], colour[3], speed)
    end

    def colourable(r, g, b, a, speed=0)
    
      # Always set the required colour as a target
      colourable_set_target(r, g, b, a)

      # If the speed is zero, we direcly to the colour
      if speed.zero?

        @r = r
        @g = g
        @b = b
        @a = a

      # Otherwise, calculate the deltas and leave it at that
      else

        @colourable_delta[:r] = (r-@r)/speed
        @colourable_delta[:g] = (g-@g)/speed
        @colourable_delta[:b] = (b-@b)/speed
        @colourable_delta[:a] = (a-@a)/speed

      end

    end


    # Takes an array of colours, to allow for an automatically rotating tint. 
    # This can be a sequence (run once) or a cycle (run forever)
    def colourable_cycle(colours,speed)
      @colourable_loop = true
      colourable_start_list(colours, speed)
    end

    def colourable_sequence(colours, speed)
      @colourable_loop = false
      colourable_start_list(colours, speed)
    end

    def colourable_start_list(colours, speed)
      @colourable_index = 0
      @colourable_speed = speed
      @colourable_colours = colours
      colourable_array(colours[0], speed)
    end


    # Method to let us know if the colour is changing, or is stable
    def colourable_changing?

      @colourable_delta.each_value { |value| return true if value.nonzero? }
      false

    end


    # Update should be called every tick, to apply any tint changes required
    def colourable_update

      # Work through each delta, to see if channels need work
      @colourable_delta.each do |channel, delta|

        # When referring to the ivars, the @ is required
        channame = channel.to_s.prepend('@')

        # Only need to do any work if the delta is nonzero
        if delta.nonzero?

          # Apply the delta
          result = instance_variable_get(channame) + delta

          # If we've reached or passed the target, set it and clear the delta
          if (delta.positive? && result>=@colourable_target[channel]) || (delta.negative? && result<=@colourable_target[channel])
            result = @colourable_target[channel]
            @colourable_delta[channel] = 0
          end

          # Lastly put the result into the proper ivar
          instance_variable_set(channame, result)

        end
      
      end

      # Now, if the colour is no longer changing, see if we have another colour
      # we should automatically be moving to
      if @colourable_colours && @colourable_colours.length>0

        unless colourable_changing?

          # Move along the array, cycling to the start if we're cycling
          @colourable_index += 1
          if @colourable_loop && @colourable_index>=@colourable_colours.length
            @colourable_index = 0
          end

          # And as long as we're not at the end, move onto the next colour
          if @colourable_index < @colourable_colours.length
            colourable_array(@colourable_colours[@colourable_index], @colourable_speed)
          end

        end

      end

    end


  end

end