Vertices!
=========

**vertices** is a 20 second true minigame, where you click the shape with the fewest edges.

This was pretty much developed as an experiment to see what I could come up with that
fit into the fairly restrictive definition of a mini game. As it turns out, it's actually
rather a fun little thing with a strong 'one more go' appeal.

The basic graphics are all mine. Sorry.

The font, icons and sound effects come from [Kenney's Game Assets](https://kenney.nl), 
whose asset packs are a fantastic resource.

The music comes from [Subspace Audio](https://juhanijunkala.com/), via 
[OpenGameArg.org](https://opengameart.org/content/5-chiptunes-action)


Design
------

Part of the motivation for developing this ahead of the Jam was to experiment with
some of the techniques that may be useful to others - specifically around trying
to merge minigames into a single launcher.

As such, all the code in **vertices** is contained in the `Vertices` module. 

All data stored in the state object is kept under `args.state.vertices`.

There is a `tick` method defined in the `Vertices` module, so that the *only* thing
called from within `main.rb` is `Vertices.tick(args)`.

This is done with the hope that any future launcher can just start calling the
**vertices** tick handler as and when required. In theory enough data is stored
into `args.state.vertices` that it should be stop/startable without too much pain.


Files
-----

All game files - code, sprites, fonts et al - are kept under `mygame\vertices`, to
avoid potential filename clashes. The only thing required in the normal `mygame\app`
folder is our `main.rb`, which requires all the actual code and calls into the 
`Vertices` tick handler.
