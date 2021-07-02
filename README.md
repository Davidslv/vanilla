# Vanilla Roguelike

This is a work in progress rogue game written in Ruby.
Most likely it will take me forever to write it... oh well!

## Demo

If you would like to watch a small demo


```
$ pry -r ./play.rb
pry(main)> Vanilla::Demo.run

```

## Playground

```
$ pry -r ./play.rb
pry(main)> Vanilla.play(rows: 10, columns: 10)

```

## Algorithms

### Binary Tree

For each cell in the grid, it randomly creates a passage either north or east.

Features a strong diagonal texture, tending toward the north-east corner of the grid.
Passages run the length of the northern row and the eastern column.

### Aldous Broder

Starts in a random cell, moves randomly from cell to cell.
It creates a passage when finds an unvisited cell.

Starts quickly, although it can take a while to finish.
This is considered unbiased, meaning it should generate mazes completely randomly.

### Recursive Backtracker

Starts at a random cell, moves randomly, avoids previously visited cells.
When there are no more possible moves, it backtracks to the most recently visited cell and continues.
It finishes when it tries to backtrack to where it started.

### Recursive Division

It begins with an open grid, no internal walls.
Adds a wall that divides the grid in half, with a passage linking both halves.
Repeats on each side until no open areas remain.

Tends to be of a boxy or rectangular texture.


### Contributing

If you are interested in contributing, please do.


### License

Vanilla is under the MIT License.
