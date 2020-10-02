# game.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is the core Game class, which manages everything

module Vertices

  # Main class, which handles the entire game world by exposing update/render
  class Game

    attr_accessor :args

    # Constructor, which creates the basic world
    def initialize(args)

      # Keep a handy reference to the args
      @args = args

      # On startup we're not running
      @running = false

      # Initialise some other bits
      @prompt = []

      # Sort out the logo that we'll use when it's required
      @logo_sprite = TintedSprite.new(w: 567, h: 135, path: 'sprites/logo.png')
      @logo_sprite.colourable_cycle(
        [
          [255, 10, 0, 255],
          [205, 10, 50, 255],
          [50, 10, 205, 255],
          [0, 10, 255, 255],
          [50, 10, 205, 255],
          [205, 10, 50, 255]
        ],
        20
      )

    end


    # Update the world
    def update

      # So, if we're running we (a) count down,(b) check we have enough shapes,
      # and (c) see if the user clicks on one of them
      if @running

        # See if we have any time left!


      # If we're not running, we're just prompting the user and waiting for
      # her to click the start button
      else

        # Update the logo sprite
        @logo_sprite.set_location((@args.grid.w - 567) / 2, 500)
        @logo_sprite.colourable_update

        # Set the correct prompt to show, either the last score of just general
        @prompt[0] = 'Click on the shape with the fewest edges'
        @prompt[1] = 'How many can you click in time?!'

        # And see if the user clicks on the button

      end

    end


    # Render the world
    def render

      # If we're running, we show the count down and draw the shaps
      if @running

      # If not, we just show the splash/prompt screen
      else

        # So, draw the logo
        @args.outputs.sprites << @logo_sprite

        # And the prompting blurb
        @prompt.each_with_index do |prompt, index|
          @args.outputs.labels << {
            x: @args.grid.center_x, y: 400 - (index * 75),
            text: prompt,
            alignment_enum: 1, size_enum: 15,
            r: 200, g: 200, b: 200, a: 255,
            font: 'fonts/Kenney Future Square.ttf'
          }
        end

        # Lastly the button to be pressed

      end

    end

  end

end

# End of game.rb
