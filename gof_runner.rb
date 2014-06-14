require_relative 'gof_spec'
require 'curses'
include Curses

def draw_world(array_of_cells)
  width = array_of_cells.size + 4
  height = array_of_cells.first.size + 2

  win = Window.new(height, width, 2, (cols - width) / 2)
  win.box(?|, ?-)

  array_of_cells.each_with_index do |row, index|
    win.setpos(index+1, 2)
    output = ''
    row.each { |cell| output += cell == 1 ? '*' : ' ' }
    win.addstr(output)
  end

  win.refresh

  sleep 0.1
  win.close
end

def show_message(message)
  width = message.length + 6
  win = Window.new(5, width,
                   (lines - 5) / 2, (cols - width) / 2)
  win.box(?|, ?-)
  win.setpos(2, 3)
  win.addstr(message)
  win.refresh
  win.getch
  win.close
end

init_screen
begin
  crmode

  world = World.new(100, 35)
  world.set_alive([5,1],[5,2],[6,1],[6,2],
                  [4,12],[3,13],[3,14],[4,16],[5,17],[6,17],[7,17],[6,18],[8,16],[6,15],[5,11],[6,11],[7,11],[8,12],[9,13],[9,14],
                  [3,21],[3,22],[4,21],[4,22],[5,21],[5,22],[2,23],[6,23],[1,25],[2,25],[6,25],[7,25],
                  [3,35],[3,36],[4,35],[4,36]
                 )

  100.times do
    draw_world(world.cells)
    refresh

    world = world.tick
  end

  show_message ("Press any key to exit.")
ensure
  close_screen
end
