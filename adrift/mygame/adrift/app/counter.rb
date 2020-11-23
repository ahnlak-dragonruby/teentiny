# counter.rb - part of adrift, a TeenyTiny Jam Game
#
# The Counter encodes a time counter, which is rendered as a large, friendly
# 7-segment display.

module Adrift

  class Counter

    # Make it serializable
    include Ahnlak::MixinSerializable

    # And set the attributes
    attr_writer :args
    attr_accessor :start_tick    
    attr_sprite

    # Constructor, where we load up what we'll need
    def initialize(args)

      # Remember our args reference
      @args = args

      # Set the start tick to something vaguely plausible
      @start_tick = @args.tick_count

      # Set our dimensions to contain ourselves
      @w = 202
      @h = 64

    end


    # Renderer, which outputs our 7-segment display based on the time passing
    # since the start_tick
    def draw_override(ffi_draw)

      # So, work out how many seconds have passed since we started; there are
      # 60 ticks per second
      seconds = (@args.tick_count - @start_tick) / 60
      hundreds = ((@args.tick_count - @start_tick) % 60) * 100 / 60

      # Extract the four digits individually
      first, second = seconds.to_i.divmod(10)
      third, fourth = hundreds.to_i.divmod(10)

      # And render the right digit
      ffi_draw.draw_sprite_3(
        @x, @y, 48, 64, 'adrift/sprites/counter-numbers.png',
        nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil,
        first*48, 0, 48, 64
      )
      ffi_draw.draw_sprite_3(
        @x + 48, @y, 48, 64, 'adrift/sprites/counter-numbers.png',
        nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil,
        second*48, 0, 48, 64
      )
      ffi_draw.draw_sprite_3(
        @x + 92, @y, 10, 64, 'adrift/sprites/counter-numbers.png',
        nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil,
        480, 0, 10, 64
      )
      ffi_draw.draw_sprite_3(
        @x + 106, @y, 48, 64, 'adrift/sprites/counter-numbers.png',
        nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil,
        third*48, 0, 48, 64
      )
      ffi_draw.draw_sprite_3(
        @x + 154, @y, 48, 64, 'adrift/sprites/counter-numbers.png',
        nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil,
        fourth*48, 0, 48, 64
      )

    end

  end

end

# End of file counter.rb
