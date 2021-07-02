# Vanilla Roguelike

This is a work in progress rogue game written in Ruby.
Most likely it will take me forever to write it... oh well!

## Install dependencies

This project uses ruby 2.7.2 (see .ruby-version).
I use rbenv to install different ruby versions, you may need to install [homebrew](https://brew.sh)


```bash
$ brew install rbenv

$ rbenv install local
$ gem install bundler
$ bundle install
```


## Demo

If you would like to watch a small demo


```ruby
$ pry -r ./play.rb
pry(main)> Vanilla::Demo.run

```

## Playground

```ruby
$ pry -r ./play.rb
pry(main)> Vanilla.play(rows: 10, columns: 10)

```

## Algorithms

### Binary Tree

For each cell in the grid, it randomly creates a passage either north or east.

Features a strong diagonal texture, tending toward the north-east corner of the grid.
Passages run the length of the northern row and the eastern column.

This is the algorithm used by default.

### Aldous Broder

Starts in a random cell, moves randomly from cell to cell.
It creates a passage when finds an unvisited cell.

Starts quickly, although it can take a while to finish.
This is considered unbiased, meaning it should generate mazes completely randomly.

```ruby
$ pry -r ./play.rb
Vanilla.play(rows: 10, columns: 15, algorithm: Vanilla::Algorithms::AldousBroder)
```

### Recursive Backtracker

Starts at a random cell, moves randomly, avoids previously visited cells.
When there are no more possible moves, it backtracks to the most recently visited cell and continues.
It finishes when it tries to backtrack to where it started.

```ruby
$ pry -r ./play.rb
Vanilla.play(rows: 10, columns: 15, algorithm: Vanilla::Algorithms::RecursiveBacktracker)
```

### Recursive Division

It begins with an open grid, no internal walls.
Adds a wall that divides the grid in half, with a passage linking both halves.
Repeats on each side until no open areas remain.

Tends to be of a boxy or rectangular texture.

```ruby
$ pry -r ./play.rb
Vanilla.play(rows: 10, columns: 15, algorithm: Vanilla::Algorithms::RecursiveDivision)
```


### Contributing

If you are interested in contributing, please do.

## Documentation

I'm using [Yard](https://rubydoc.info/gems/yard/0.9.26/file/README.md) to create documentation.

**Creates HTML documentation**

```bash
$ yard doc
```

**Starts web server**

Open your browser and go to http://localhost:8808/

```bash
$ yard server
```

### License

Vanilla is under the MIT License.
