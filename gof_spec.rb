require 'rspec'

class World
  attr_reader :cells

  def initialize(rows, columns)
    @cells = Array.new(rows) { Array.new(columns) { 0 } }
  end

  def set_alive(*array_of_live_cells)
    array_of_live_cells.each do |location|
      @cells[location[0]][location[1]] = 1
    end
  end

  def total_live_neighbours(cell_x, cell_y)
    count = 0
    neighbours_coordinates = [ [-1, -1], [-1, 0], [-1, 1],
                               [ 0, -1],          [ 0, 1],
                               [ 1, -1], [ 1, 0], [ 1, 1] ]
    neighbours_coordinates.each do |x, y|
      next if cell_x + x < 0 || cell_y + y < 0
      count += 1 if @cells[cell_x + x] != nil && @cells[cell_x + x][cell_y + y] == 1
    end

    count
  end

  def tick
    @next_world = World.new(@cells.size, @cells.first.size) 
    @cells.each_with_index do |row, x_index|
      row.each_with_index do |_, y_index|
        alive_neighbours = total_live_neighbours(x_index, y_index)
        @next_world.set_alive([ x_index, y_index ]) if (@cells[x_index][y_index] == 1 && (alive_neighbours == 2 || alive_neighbours == 3)) || alive_neighbours == 3
      end
    end

    @next_world
  end
end

describe 'Game of Life' do
  describe World do
    it 'should have a matrix of cells' do
      world = World.new(1,1)
      world.cells.should == [[0]]
    end

    describe '#set_alive' do
      it 'should set an array of cells to be alive' do
        world = World.new(3,3)
        world.set_alive([0,0], [0,1], [0,2])
        world.cells.should == [[1,1,1], [0,0,0], [0,0,0]]
      end
    end

    describe '#total_live_neighbours' do
      it 'should return 8 for center cell in ***|***|***' do
        world = World.new(3,3)

        world.cells.each_with_index do |row, x_index|
          row.each_with_index do |_, y_index|
            world.set_alive([x_index, y_index])
          end
        end

        world.total_live_neighbours(1,1).should == 8
      end
    end

    context 'Any live cell with fewer than two live neighbours dies, as if caused by underpopulation' do
      it 'should return an empty world for *..' do
        world = World.new(1,3)
        world.set_alive(0,0)
        world = world.tick
        world.cells.should == [[0,0,0]]
      end
    end

    context 'Any live cell with two or three live neighbours lives on to the next generation' do
      it 'should return the same world for **.|**.' do
        world = World.new(2,3)
        world.set_alive([0,0], [0,1], [1,0], [1,1])
        world.tick.cells.should == world.cells
      end
    end

    context 'Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction' do
      it 'should return a full world for .*|**' do
        world = World.new(2,2)
        world.set_alive([0,1], [1,0], [1,1])
        world = world.tick
        world.cells.should == [[1,1], [1,1]]
      end
    end

    context 'Blinker' do
      it '.*.|.*.|.*. changes to ...|***|... and back' do
        world = World.new(3,3)
        world.set_alive([0,1], [1,1], [2,1])
        world = world.tick
        world.cells.should == [[0,0,0], [1,1,1], [0,0,0]]
        world = world.tick
        world.cells.should == [[0,1,0], [0,1,0], [0,1,0]]
        world = world.tick
        world.cells.should == [[0,0,0], [1,1,1], [0,0,0]]
        world = world.tick
        world.cells.should == [[0,1,0], [0,1,0], [0,1,0]]
      end
    end
  end
end
