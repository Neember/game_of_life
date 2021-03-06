require_relative 'gof'
require 'awesome_print'
require 'curses'
include Curses

def draw_world(win_handle, array_of_cells)
  array_of_cells.each_with_index do |row, x_index|
    y_index = 2
    row.each do |cell| 
      color, symbol = cell == 1 ? [COLOR_RED, '*'] : [COLOR_BLUE, '.']
      win_handle.attron(color_pair(color)){
        win_handle.setpos(x_index+1, y_index)
        win_handle.addstr(symbol)
        y_index += 1
      }
    end
  end

  sleep 0.1
  win_handle.refresh
end

def show_message(message)
  width = message.length + 6
  win = Window.new(5, width, (lines - 5) / 2, (cols - width) / 2)
  win.box(?|, ?-)
  win.setpos(2, 3)
  win.addstr(message)
  win.refresh
  win.getch
  win.close
end

def display_status(generation_count)
  message = "Generation Count: #{generation_count}"
  width = message.length + 6
  win = Window.new(5, width, (lines - 2), (cols - width) / 2)
  win.setpos(0, 0)
  win.addstr(message)
  win.refresh
  win.close
end

init_screen
begin
  init_screen
  start_color
  init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_WHITE)
  init_pair(COLOR_RED,COLOR_RED,COLOR_WHITE)
  crmode
  curs_set 0
  
  title = 'Game of Life Stimulation'
  setpos(2, (cols - title.size) / 2)
  addstr(title)
  refresh

  world = World.new(30, 100)
  world.set_alive([5, 1], [6, 1], [5, 2], [6, 2], [5, 11], [6, 11], [7, 11], [4, 12], [8, 12], [3, 13], [9, 13], [3, 14], [9, 14], [6, 15], [4, 16], [8, 16], [5, 17], [6, 17], [7, 17], [6, 18], [3, 21], [4, 21], [5, 21], [3, 22], [4, 22], [5, 22], [2, 23], [6, 23], [1, 25], [2, 25], [6, 25], [7, 25], [3, 35], [4, 35], [3, 36], [4, 36], [22, 35], [23, 35], [25, 35], [22, 36], [23, 36], [25, 36], [26, 36], [27, 36], [28, 37], [22, 38], [23, 38], [25, 38], [26, 38], [27, 38], [23, 39], [25, 39], [23, 40], [25, 40], [24, 41]) 


  width = world.cells.first.size + 4
  height = world.cells.size + 2
  world_window = Window.new(height, width, (lines - height) / 2, (cols - width) / 2)
  world_window.box(?|, ?-)

  300.times do |index|
    draw_world(world_window, world.cells)
    display_status(index+1)

    world = world.tick
  end

  world_window.close

  show_message ("Press any key to exit.")
ensure
  close_screen
end
