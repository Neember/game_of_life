class World
  attr_reader :cells

  def initialize(rows, columns)
    @cells = Array.new(rows) { Array.new(columns) { 0 } }
  end

  def set_alive(*array_of_live_cells)
    array_of_live_cells.each do |x, y|
      @cells[x][y] = 1
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
        if (@cells[x_index][y_index] == 1 && alive_neighbours == 2) || alive_neighbours == 3
          @next_world.set_alive([ x_index, y_index ]) 
        end
      end
    end

    @next_world
  end
end
