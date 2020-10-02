# main.rb - part of Vertices, a TeenyTiny Jam Game
#
# With a view to easing future integrations with an imaginary launcher, the
# entire game is wrapped in a Module, so all the main tick method does is
# to hand control into Vertices::tick
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>

require 'app/ahnlak/mixin_colourable.rb'
require 'app/ahnlak/mixin_serializable.rb'
require 'app/game.rb'
require 'app/tinted_sprite.rb'
require 'app/vertices.rb'


def tick(args)

  Vertices.tick(args)

end
