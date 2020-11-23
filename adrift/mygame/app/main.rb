# main.rb - part of adrift, a TeenyTiny Jam Game
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
require 'adrift/app/adrift.rb'
require 'adrift/app/counter.rb'
require 'adrift/app/game.rb'
require 'adrift/app/player.rb'
require 'adrift/app/tinted_label.rb'
require 'adrift/app/tinted_sprite.rb'


def tick(args)

  Adrift.tick(args)

end
