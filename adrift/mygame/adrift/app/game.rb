# game.rb - part of adrift, a TeenyTiny Jam Game
#
# This is the core Game class, which manages everything

module Adrift

  class Game

    include Ahnlak::MixinSerializable
    attr_reader :args

    # Constructor, which creates the basic world
    def initialize(args)

      # Keep a handy reference to the args
      @args = args

      # On startup we're not running
      @args.state.adrift.running = false

      # We'll definitely need a player object!
      @player = Player.new(args)

      # Need an audio handler
      @audio_handler = Ahnlak::ClassAudio.new
      @audio_handler.play('adrift/sounds/ObservingTheStar.ogg')

      # And load up our sprites
      load_sprites

      # And the prompts we show
      @prompt = []
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 600,
        alignment_enum: 1, size_enum: 10,
        text: 'Move your mouse to rotate your ship.',
        font: 'adrift/fonts/Kenney Rocket Square.ttf'
      )
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 550,
        alignment_enum: 1, size_enum: 10,
        text: 'Click to fire your engines.',
        font: 'adrift/fonts/Kenney Rocket Square.ttf'
      )
      @prompt << TintedLabel.new(
        visible: true,
        x: @args.grid.center_x, y: 225,
        alignment_enum: 1, size_enum: 7,
        text: "Can you stay on the screen for 20 seconds?!",
        font: 'adrift/fonts/Kenney Rocket Square.ttf'
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

      # The system icons are static
      args.outputs.static_sprites << @audio_sprite
      args.outputs.static_sprites << @music_sprite

    end


    # Setter for args; needed to reflect args out to other objects
    def args=(args)

      # Save the args reference
      @args = args

      # And pass it to the player
      @player.args = args

    end


    # Toggles for music and audio flags
    def enable_audio(on: true)

      # Set the flag
      @audio_handler.audio = on

      # Update the icon
      @audio_sprite.path =
        if @audio_handler.audio
          'adrift/sprites/audioOn.png'
        else
          'adrift/sprites/audioOff.png'
        end

    end

    def enable_music(on: true)

      # Set the flag
      @audio_handler.music = on

      # Update the icon
      @music_sprite.path =
        if @audio_handler.music
          'adrift/sprites/musicOn.png'
        else
          'adrift/sprites/musicOff.png'
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

      # And the start button
      @button_sprite = TintedSprite.new(w: 256, h: 64, path: 'adrift/sprites/start.png')
      @button_sprite.movable_location((@args.grid.center_x - 128), 350)
      @button_sprite.colourable_cycle(
        [
          [255, 255, 255, 255],
          [128, 128, 128, 255]
        ], 10
      )

      # Lastly, music and audio icons
      @audio_sprite = TintedSprite.new(w: 50, h: 50, path: 'adrift/sprites/audioOn.png')
      @audio_sprite.movable_location((@args.grid.w - 60), 10)
      @audio_sprite.colourable_cycle(
        [
          [255, 200, 200, 128],
          [200, 200, 255, 128]
        ], 60
      )
      @music_sprite = TintedSprite.new(w: 50, h: 50, path: 'adrift/sprites/musicOn.png')
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

      # Check to see if the music and sound toggles have been clicked
      if @args.inputs.mouse.click

        toggle_music if @music_sprite.contains?(@args.inputs.mouse.click.point)
        toggle_audio if @audio_sprite.contains?(@args.inputs.mouse.click.point)

      end

      # And the system icons
      @audio_sprite.update
      @music_sprite.update

      # Call the appropriate updater, depending on what mode we're in
      if @args.state.adrift.running
        update_running
      else
        update_title
      end

    end

    def update_running

      # Rotate the player to point at the mouse
      @player.angle = @player.angle_to(@args.inputs.mouse.position)

      # If the player presses the mouse button, apply thrust
      @player.thrust if @args.inputs.mouse.click

      # Now update the player object
      @player.update

    end

    def update_title

      # Make sure that the labels are updated
      @prompt.each { |label| label.update }

      # And see if the user clicks on the button
      @button_sprite.update
      if @args.inputs.mouse.click && @button_sprite.contains?(@args.inputs.mouse.click.point)

        # Reset the game state
        reset

        # Set the timer running from this point
        @args.state.adrift.start_tick = @args.tick_count

        # And flag ourselves as running
        @args.state.adrift.running = true

      end

    end


    # Reset the game to a good starting position
    def reset

      # Set the player location to the center of the screen
      @player.x = @args.grid.center_x
      @player.y = @args.grid.center_y

      # And set us drifting in a random direction, but a non-random speed...
      @player.angle = 360.randomize(:int)
      @player.thrust(2)

    end


    # Render the world
    def render

      # We render different things depending on our mode, obviously
      @args.state.adrift.running ? render_running : render_title

    end

    def render_running

      # Send the player object to the screen
      @args.outputs.primitives << @player

    end

    def render_title

      # Show the main prompts
      @prompt.each { |prompt| @args.outputs.labels << prompt }

      # And the start button, obviously
      @args.outputs.primitives << @button_sprite

    end

  end

end

# End of game.rb
