# game.rb - part of adrift, a TeenyTiny Jam Game
#
# This is the 'main' of the application, tucked away safely in our module

# All code is wrapped inside the Adrift namespace; all main.rb needs to do
# is to call into Adrift.tick each tick.

module Adrift

  def self.init(args)

    # Everything important is wrapped in the Game object
    @game = Game.new(args)

    # Tag the release version
    args.state.adrift.version = '0.0.1'
    args.outputs.static_labels << {
      x: 10, y: 25, size_enum: 0,
      font: 'adrift/fonts/Kenney Rocket Square.ttf',
      r: 200, g: 200, b: 200, a: 128,
      text: "Version #{args.state.adrift.version}"
    }

    # Set the nice nebula backdrop
    args.outputs.static_sprites << {
      x: 0, y: 0, w: 1280, h: 720,
      a: 64, path: 'adrift/sprites/orion-nebula.png'
    }

    # Lastly, flag that we're definitely intialised
    args.state.adrift.initialized = true

  end


  def self.tick(args)

    # If we're not initialised, do so
    Adrift.init(args) if args.state.adrift.initialized != true

    # Set the basic screen parameters
    args.outputs.background_color = [16, 0, 32, 255]

    # Make sure the Game has an uptodate copy of args
    @game.args = args

    # Update the game
    @game.update

    # And then render it
    @game.render

  end

end

# End of adrift.rb
