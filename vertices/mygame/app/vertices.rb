# vertices.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is the 'main' of the application, tucked away safely in our module

module Vertices

  def self.init(args)

    # Everything important is wrapped in the Game object
    @game = Game.new(args)

    # Lastly, flag that we're definitely intialised
    args.state.vertices.initialized = true

  end


  def self.tick(args)

    # If we're not initialised, do so
    if args.state.vertices.initialized != true
      Vertices::init(args)
    end

    # Set the basic screen parameters
    args.outputs.background_color = [ 32, 0, 64, 255 ]

    # Make sure the Game has an uptodate copy of args
    @game.args = args

    # Update the game
    @game.update

    # And then render it
    @game.render

  end

end

# End of vertices.rb