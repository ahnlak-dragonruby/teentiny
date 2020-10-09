# tinted_label.rb - part of Vertices, a TeenyTiny Jam Game
#
# This is a regular DR label, with colourable and moveable mixins added

module Vertices

  # A lightweight wrapper around a DR label, adding in some utility mixins
  class TintedLabel

    # Pull in various mixins and attributes
    include Ahnlak::MixinColourable
    include Ahnlak::MixinMovable
    include Ahnlak::MixinSerializable

    # One day, this should be wrapped in attr_label...
    attr_accessor :x, :y, :text, :size_enum, :alignment_enum, :font, :r, :g, :b, :a
    def primitive_marker
      :label
    end

    # Constructor; takes the usual sprite hash
    # rubocop:disable Style/GuardClause
    def initialize(**params)

      # Set some colour defaults
      colourable(255, 255, 255, 255, 0)

      # Store the parameters we find in our ivars
      params.each do |key, value|
        instance_variable_set(key.to_s.prepend('@'), value)
      end

      # If we're set as not visible, move the label off screen
      unless @visible
        @x = $gtk.args.grid.w + 10
        @y = $gtk.args.grid.h + 10
      end

    end
    # rubocop:enable Style/GuardClause

    # Central update, that works through all the mixin updates
    def update
      colourable_update
      movable_update
    end

  end

end

# End of tinted_sprite.rb
