require 'colorize'
require_relative 'cursor'
class Display
  include Cursor
  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def update_board(board)
    @board = board
  end

  def render
    puts "  #{(0..9).to_a.join(" ")}"
    @board.grid.each_with_index do |row, row_num|
      print "#{row_num} "
      row.each_with_index do |col, col_num|
        if [row_num, col_num] == @cursor_pos
          print "O".colorize(:light_yellow).blink
        else
          print col.show(false)
        end
        print " "
      end
      puts ""
    end
    puts "#{@board.ships_sunk.join(", ")} sunk" unless @board.ships_sunk.empty?
  end

  def render_own
    puts "  #{(0..9).to_a.join(" ")}"
    @board.grid.each_with_index do |row, row_num|
      print "#{row_num} "
      row.each_with_index do |col, col_num|
        print col.show(true)
        print " "
      end
      puts ""
    end
  end

  def move_cursor
  end
end
