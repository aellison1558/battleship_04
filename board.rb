require_relative 'tile'
class Board
attr_reader :grid
SHIPS = {
  "Carrier" => {tag: "CV", size: 5},
  "Battleship" => {tag: "BB", size: 4},
  "Submarine" => {tag: "SB", size: 3},
  "Destroyer" => {tag: "DD", size: 3},
  "PT_Boat" => {tag: "PT", size: 2}
}
  def initialize
    @grid = Array.new(10) {Array.new(10, nil)}
    populate
    build_tiles
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end

  def build_tiles
    puts "In build tiles!"
    @grid.each_with_index do |row, row_idx|
      puts "in first loop"
      row.each_with_index do |col, col_idx|
        puts "in second loop"
        pos = [row_idx, col_idx]
        p pos
        if col
          self[pos] = Tile.new([:s, col[:tag]], self, pos)
        else
          self[pos] = Tile.new(nil, self, pos)
        end
      end
    end
  end

  def all_ships_sunk?
    @grid.flatten.each do |tile|
      return false if tile.value.is_a?(Array) && !tile.hit
    end
    true
  end

  def ships_sunk
    sunk = []
    SHIPS.each do |ship_name, ship|
      ship_tiles = []
      @grid.flatten.select do |tile|
        if tile.value
          ship_tiles << tile if tile.value[1] == ship[:tag]
        end
      end
      sunk << ship_name if ship_tiles.all? {|tile| tile.hit}
    end
    sunk
  end

  def shoot_at(shot)
    self[shot].get_shot
    self[shot].value == :s ? true : false
  end

  def populate
    SHIPS.each do |ship_name, ship|
      ship_location = choose_location
      until valid_location?(ship_location[0], ship_location[1], ship[:size])
        ship_location = choose_location
      end
      place_ship(ship_location, ship)
    end
  end

  def choose_location
    position = [rand(10), rand(10)]
    direction = rand(4)
    [position, direction]
  end

  def valid_location?(position, direction, size)
    case direction
    when 0
      check_vertical(position, "subtract", size)
    when 1
      check_horizontal(position, "subtract", size)
    when 2
      check_vertical(position, "add", size)
    when 3
      check_horizontal(position, "add", size)
    end
  end

  def check_vertical(position, up_or_down, size)
    if up_or_down == "subtract"
      y_pos = position[0] - (size - 1)
      return false if y_pos < 0
      (y_pos..position[0]).each do |row|
        return false if self[[row, position[1]]]
      end
      true
    else
      y_pos = position[0] + (size - 1)
      return false if y_pos > 9
      (position[0]..y_pos).each do |row|
        return false if self[[row, position[1]]]
      end
      true
    end
  end

  def check_horizontal(position, left_or_right, size)
    if left_or_right == "subtract"
      x_pos = position[1] - (size - 1)
      return false if x_pos < 0
      (x_pos..position[1]).each do |col|
        return false if self[[position[0], col]]
      end
      true
    else
      x_pos = position[1] + (size - 1)
      return false if x_pos > 9
      (position[1]..x_pos).each do |col|
        return false if self[[position[0], col]]
      end
      true
    end
  end

  def in_bounds?(pos)
    if pos[0].between?(0, 9) && pos[1].between?(0,9)
      true
    else
      false
    end
  end

  def place_ship(position_direction, ship)
    p ship[:size]
    row = position_direction[0][0]
    col = position_direction[0][1]
    direction = position_direction[1]
    case direction
    when 0
      new_row = row - (ship[:size] - 1)
      (new_row..row).each do |row|
        self[[row, col]] = ship
      end
    when 1
      new_col = col - (ship[:size] - 1)
      (new_col..col).each do |col|
        self[[row, col]] = ship
      end
    when 2
      new_row = row + (ship[:size] - 1)
      (row..new_row).each do |row|
        self[[row, col]] = ship
      end
    when 3
      new_col = col + (ship[:size] - 1)
      (col..new_col).each do |col|
        self[[row, col]] = ship
      end
    end
  end
end
