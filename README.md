# README

Sample solution to Conway's Game of Life http://en.wikipedia.org/wiki/Conway's_Game_of_Life with a simulator to run your solution using Curses http://www.ruby-doc.org/stdlib-2.0/libdoc/curses/rdoc/Curses.html

# Game of life Simulation

- Put your own solution in the file `lib/gof.rb`
- Make sure your solution has a World class with a public method cells that returns an array of cells that is 1 for living and 0 for dead.
```
# Example return for 
# .*.
# ***
# ...
World.cells => returns [[0,1,0], [1,1,1],[0,1,0]]
```
- Finally, run the simulator using `rake gof`
