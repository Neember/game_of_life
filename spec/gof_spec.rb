require_relative '../lib/gof'
require 'rspec'

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
        world.set_alive([0,0])
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
