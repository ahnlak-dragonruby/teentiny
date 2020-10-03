# game.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is the core Game class, which manages everything

module Vertices

  # Main class, which handles the entire game world by exposing update/render
  class Game

    include Ahnlak::MixinSerializable
    attr_accessor :args

    # Constructor, which creates the basic world
    def initialize(args)

      # Keep a handy reference to the args
      @args = args

      # On startup we're not running
      @args.state.vertices.running = false

      # Set some basic game parameters
      @args.state.vertices.play_ticks ||= 10.seconds
      @args.state.vertices.polygons ||= []
      @polygons = []

      # Initialise some other bits - again, set some defaults
      @prompt = []
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 400,
        alignment_enum: 1, size_enum: 15,
        text: 'Click on the shape with the fewest edges',
        font: 'fonts/Kenney Future Square.ttf'
      )
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 325,
        alignment_enum: 1, size_enum: 15,
        text: 'How many can you click in time?!',
        font: 'fonts/Kenney Future Square.ttf'
      )
      @prompt.each do |prompt|
        prompt.colourable_cycle(
          [
            [255, 255, 255, 255],
            [100, 255, 100, 255],
            [255, 100, 255, 255]
          ],
          30
        )
      end

      # And load up our sprites
      load_sprites

    end


    # Load up the sprites which will always be used
    def load_sprites

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
        ], 15
      )
      @logo_sprite.movable_location_cycle(
        [
          [(@args.grid.w - 547) / 2, 480],
          [(@args.grid.w - 567) / 2, 520],
          [(@args.grid.w - 587) / 2, 500],
          [(@args.grid.w - 567) / 2, 480],
          [(@args.grid.w - 547) / 2, 500],
          [(@args.grid.w - 567) / 2, 520],
          [(@args.grid.w - 587) / 2, 480],
          [(@args.grid.w - 567) / 2, 500]
        ], 60
      )

      # And the start button
      @button_sprite = TintedSprite.new(w: 256, h: 64, path: 'sprites/start.png')
      @button_sprite.movable_location((@args.grid.center_x - 128), 128)
      @button_sprite.colourable_cycle(
        [
          [255, 255, 255, 255],
          [128, 128, 128, 255]
        ], 10
      )

    end


    # Update the world
    def update

      # Call the appropriate updater, depending on what mode we're in
      if @args.state.vertices.running

        update_running

      else

        update_title

      end

    end

    # Handles updates when we are running
    def update_running

      # So, if we're running we (a) count down,(b) check we have enough shapes,
      # and (c) see if the user clicks on one of them

      # (a) count down, and handle if we're out of time
      if @args.tick_count > @args.state.vertices.start_tick + @args.state.vertices.play_ticks

        # Update the prompts to record the total count of objects
        @prompt[0].text = "You managed to click on #{@args.state.vertices.shape_count} shapes!"
        @prompt[1].text = 'Can you get click on even more?!'

        # And stop the running state
        @args.state.vertices.running = false

      end

      # (b) work out how many shapes we should have, and if we don't have enough
      # then spawn some more
      shape_count = (3 + (@args.tick_count - @args.state.vertices.start_tick) / 180).to_i
      while @args.state.vertices.polygons.length < shape_count
        @args.state.vertices.polygons << {
          vertices: 3 + 7.randomize(:ratio).to_i
        }
      end

      # We need to make sure that our polygon list reflects what's in the state
      @args.state.vertices.polygons.each do |polygon|

        # If we have a path defined, find it in our polygon list and update locations
        if polygon.has_key?(:path)

        # Then we need to create a new one
        else

          # Spawn it, and save the path of it
          new_poly = RegularPolygon.new(args, 32, polygon[:vertices])
          polygon[:path] = new_poly.path

          # Finally add it to our internal list
          @polygons << new_poly

        end

      end

    end

    # Handle updates when we're at the title screen
    def update_title

      # Update the logo sprite
      @logo_sprite.update

      # And the prompt label(s)
      drift_x = @args.grid.center_x + 15.randomize(:ratio, :sign)
      drift_y = 400 + 5.randomize(:ratio, :sign)

      @prompt.each_with_index do |label, idx|

        # If we're stationary, pick a new random location to drift to
        label.movable_location(drift_x, drift_y - (idx * 75), 30) unless label.movable_moving?

        # And lastly, update it
        label.update

      end

      # And see if the user clicks on the button
      @button_sprite.update
      if @args.inputs.mouse.click &&
         @args.inputs.mouse.click.point.x.between?(@args.grid.center_x - 128, @args.grid.center_x + 128) &&
         @args.inputs.mouse.click.point.y.between?(128, 192)

        # Set the timer running from this point
        @args.state.vertices.start_tick = @args.tick_count

        # Set the shape count to zero
        @args.state.vertices.shape_count = 0

        # And flag ourselves as running
        @args.state.vertices.running = true

      end

    end



    # Render the world
    def render

      # If we're running, we show the count down and draw the shaps
      if @args.state.vertices.running

        # Draw the timer band across the top of the screen, as a solid
        column = (@args.grid.w / @args.state.vertices.play_ticks) * (@args.tick_count - @args.state.vertices.start_tick)
        @args.outputs.solids << {
          x: 0, y: @args.grid.top - 10, w: column, h: 10,
          r: 255, g: 10, b: 10, a: 255
        }

        # And draw each polygon
        @args.outputs.sprites << @polygons

      # If not, we just show the splash/prompt screen
      else

        # So, draw the logo
        @args.outputs.sprites << @logo_sprite

        # And work through the prompts, spacing them slightly sensibly
        @prompt.each { |prompt| @args.outputs.labels << prompt }

        # Lastly the button to be pressed
        @args.outputs.sprites << @button_sprite

      end

    end

  end

end

# End of game.rb
