# main.rb - part of Vertices, a TeenyTiny Jam Game
#
# With a view to easing future integrations with an imaginary launcher, the
# entire game is wrapped in a Module, so all the main tick method does is
# to hand control into Vertices::tick
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>

require 'ahnlak/class_audio.rb'
require 'ahnlak/mixin_colourable.rb'
require 'ahnlak/mixin_movable.rb'
require 'ahnlak/mixin_serializable.rb'
require 'vertices/app/counter.rb'
require 'vertices/app/game.rb'
require 'vertices/app/regular_polygon.rb'
require 'vertices/app/tinted_label.rb'
require 'vertices/app/tinted_sprite.rb'
require 'vertices/app/vertices.rb'


def tick(args)

  Vertices.tick(args)

end
