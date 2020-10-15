# game.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is the core Game class, which manages everything

module Vertices

  # Main class, which handles the entire game world by exposing update/render
  class Game

    include Ahnlak::MixinSerializable
    attr_reader :args

    # Constructor, which creates the basic world
    def initialize(args)

      # Keep a handy reference to the args
      @args = args

      # On startup we're not running
      @args.state.vertices.running = false

      # Set some basic game parameters
      @args.state.vertices.play_ticks ||= 20.seconds
      @args.state.vertices.target_shapes ||= 10
      @args.state.vertices.polygons ||= []
      @polygons = []
      @stars = []

      # Need an audio handler
      @audio_handler = Ahnlak::ClassAudio.new
      @audio_handler.play('vertices/sounds/title.ogg')

      # Initialise some other bits - again, set some defaults
      @prompt = []
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 400,
        alignment_enum: 1, size_enum: 15,
        text: 'Click on the shape with the fewest edges',
        font: 'vertices/fonts/Kenney Future Square.ttf'
      )
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 325,
        alignment_enum: 1, size_enum: 15,
        text: "Can you clear #{@args.state.vertices.target_shapes} shapes in time?!",
        font: 'vertices/fonts/Kenney Future Square.ttf'
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
      @counter = Counter.new(args)

      # And load up our sprites
      load_sprites

      # The system icons are static
      args.outputs.static_sprites << @audio_sprite
      args.outputs.static_sprites << @music_sprite

    end


    # Setter for args; needed to reflect args out to polygon sprites
    def args=(args)

      # Save the args reference
      @args = args

      # And echo that to the polygons
      @polygons.each { |polygon| polygon.args = args }

    end


    # Toggles for music and audio flags
    def enable_audio(on: true)

      # Set the flag
      @audio_handler.audio = on

      # Update the icon
      @audio_sprite.path =
        if @audio_handler.audio
          'vertices/sprites/audioOn.png'
        else
          'vertices/sprites/audioOff.png'
        end

    end

    def enable_music(on: true)

      # Set the flag
      @audio_handler.music = on

      # Update the icon
      @music_sprite.path =
        if @audio_handler.music
          'vertices/sprites/musicOn.png'
        else
          'vertices/sprites/musicOff.png'
        end

    end

    def toggle_audio
      enable_audio(on: !@audio_handler.audio)
    end

    def toggle_music
      enable_music(on: !@audio_handler.music)
    end


    # Load up the sprites which will always be used
    def load_sprites

      # Sort out the logo that we'll use when it's required
      @logo_sprite = TintedSprite.new(w: 567, h: 135, path: 'vertices/sprites/logo.png')
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
      @button_sprite = TintedSprite.new(w: 256, h: 64, path: 'vertices/sprites/start.png')
      @button_sprite.movable_location((@args.grid.center_x - 128), 128)
      @button_sprite.colourable_cycle(
        [
          [255, 255, 255, 255],
          [128, 128, 128, 255]
        ], 10
      )

      # Lastly, music and audio icons
      @audio_sprite = TintedSprite.new(w: 50, h: 50, path: 'vertices/sprites/audioOn.png')
      @audio_sprite.movable_location((@args.grid.w - 60), 10)
      @audio_sprite.colourable_cycle(
        [
          [255, 200, 200, 128],
          [200, 200, 255, 128]
        ], 60
      )
      @music_sprite = TintedSprite.new(w: 50, h: 50, path: 'vertices/sprites/musicOn.png')
      @music_sprite.movable_location((@args.grid.w - 110), 10)
      @music_sprite.colourable_cycle(
        [
          [255, 200, 200, 128],
          [200, 200, 255, 128]
        ], 60
      )

    end


    # Update the world
    def update

      # Update the audio class before anything else
      @audio_handler.update

      # Keep the starfield moving
      update_starfield

      # Check to see if the music and sound toggles have been clicked
      if @args.inputs.mouse.click

        toggle_music if @music_sprite.contains?(@args.inputs.mouse.click.point)
        toggle_audio if @audio_sprite.contains?(@args.inputs.mouse.click.point)

      end

      # And the system icons
      @audio_sprite.update
      @music_sprite.update

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
      if @args.tick_count > @args.state.vertices.start_tick + @args.state.vertices.play_ticks ||
         @args.state.vertices.shape_count >= @args.state.vertices.target_shapes

        # Update the prompts to reflect the success or otherwise
        if @args.state.vertices.shape_count >= @args.state.vertices.target_shapes

          # If they've succeeded, how about we make it a bit more challenging?!
          @args.state.vertices.target_shapes += 2

          # And sort out the prompt
          secs_left = (20 - ((@args.tick_count - @args.state.vertices.start_tick) / 60)).to_i
          @prompt[0].text = "You managed it with #{secs_left} seconds left!"
          @prompt[1].text = "Can you get #{@args.state.vertices.target_shapes} shapes now?"

        else
          @prompt[0].text = "You only managed #{@args.state.vertices.shape_count} shapes!"
          @prompt[1].text = 'Can you do better?'
        end

        # Clear out the active polygons
        @args.state.vertices.polygons.clear
        @polygons.clear

        # Make sure to hide the counter
        @counter.a = 0

        # And stop the running state
        @args.state.vertices.running = false

        # Switch back to the title music
        @audio_handler.play('vertices/sounds/title.ogg')

        # Skip the rest of the processing
        return

      end

      # (b) work out how many shapes we should have, and if we don't have enough
      # then spawn some more
      shape_count = (3 + (@args.tick_count - @args.state.vertices.start_tick) / 180).to_i
      while @args.state.vertices.polygons.length < shape_count
        @args.state.vertices.polygons << { vertices: 3 + 6.randomize(:ratio).to_i }
      end
      @counter.update

      # We need to make sure that our polygon list reflects what's in the state
      spawn_polygons

      # Finally (c), see if the user clicked and then check if it was on a
      # polygon. So, what's the lowest vertex count?
      min_vertex = @polygons.min { |a, b| a.vertices <=> b.vertices }.vertices
      if @args.inputs.mouse.click

        # Look through the polygons, seeing if we have a hit
        hits = @polygons.select { |shape| shape.contains(@args.inputs.mouse.click.point) }

        # And then for each one, see if it's the lowest vertex count
        hits.each do |shape|

          # If it's legit then increase the counter and erase the polygon
          if shape.vertices <= min_vertex

            # Keep track of how many shapes they've clicked
            @args.state.vertices.shape_count += 1
            @counter.count = @args.state.vertices.shape_count

            # Remove the polygon they clicked on
            @polygons.delete(shape)
            @args.state.vertices.polygons.delete_if { |poly| poly[:path] == shape.path }
            @audio_handler.play('vertices/sounds/hit.wav')
            next

          end

          # In this case, we've clicked on a shape with too many sides!
          @audio_handler.play('vertices/sounds/miss.wav')

        end

      end

      # And finally, make sure we keep our polygon sprites updated
      @polygons.each(&:update)

    end


    # Run through the polygons in args.state, and ensure that we have all the
    # appropriate RegularPolygon objects spawned
    def spawn_polygons

      @args.state.vertices.polygons.each do |polygon|

        # If we have a path defined, find it in our polygon list and update locations
        if polygon.key?(:path)

        # Then we need to create a new one
        else

          # Spawn it, and save the path of it
          new_poly = RegularPolygon.new(args, 64, polygon[:vertices])
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

        # Start the right music
        @audio_handler.play('vertices/sounds/play.ogg')

        # And flag ourselves as running
        @args.state.vertices.running = true

      end

    end


    # Maintain a nice starfield to drive through
    def update_starfield

      # We should always have roughly the same star density, but let's not
      # spawn them *all* at ones
      if @stars.length < 250

        # So, spawn up to a few of them
        10.randomize(:ratio).to_i.times do
          @stars << {
            x: @args.grid.center_x, y: @args.grid.center_y,
            dx: 5.randomize(:ratio, :sign), dy: 5.randomize(:ratio, :sign),
            age: 0, show: 25.randomize(:ratio),
            r: 100 + 155.randomize(:ratio), g: 100 + 155.randomize(:ratio), b: 100 + 155.randomize(:ratio)
          }
        end

      end

      # And then work through all stars applying the delta
      @stars.each do |star|
        star[:x] += star[:dx]
        star[:y] += star[:dy]
      end

      # And prune any that fall off the screen
      @stars.delete_if do |star|
        star[:x].negative? || star[:x] > @args.grid.w || star[:y].negative? || star[:y] > @args.grid.h
      end

    end

    def render_starfield

      # Just draw a one pixel solid for each star
      @stars.each do |star|
        if star[:age] > star[:show]
          @args.outputs.solids << {
            x: star[:x], y: star[:y], w: 1, h: 1,
            r: star[:r], g: star[:g], b: star[:b], a: 255
          }
        end
        star[:age] += 1
      end

    end


    # Render the world
    def render

      # Whatever mode we're in, we always want a starfield
      render_starfield

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

        # Draw a splash if there is one
        @args.outputs.sprites << @counter if @counter.visible?

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
