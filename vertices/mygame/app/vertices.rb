# vertices.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is the 'main' of the application, tucked away safely in our module

# All code is wrapped inside the Vertices namespace; all main.rb needs to do
# is to call into Vertices.tick each tick.
module Vertices

  def self.init(args)

    # Everything important is wrapped in the Game object
    @game = Game.new(args)

    # Start playing a really annoying tune
    args.outputs.sounds << 'sounds/title.ogg'

    # Tag the release version
    args.state.vertices.version = '0.1.1'
    args.outputs.static_labels << { 
      x: 10, y: 25, size_enum: 0, 
      font: 'fonts/Kenney Future Square.ttf',
      r: 200, g: 200, b: 200, a: 128,
      text: "Version #{args.state.vertices.version}" 
    }

    # Lastly, flag that we're definitely intialised
    args.state.vertices.initialized = true

  end


  def self.tick(args)

    # If we're not initialised, do so
    Vertices.init(args) if args.state.vertices.initialized != true

    # Set the basic screen parameters
    args.outputs.background_color = [32, 0, 64, 255]

    # Make sure the Game has an uptodate copy of args
    @game.args = args

    # Update the game
    @game.update

    # And then render it
    @game.render

  end

end

# End of vertices.rb
