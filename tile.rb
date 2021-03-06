require 'colorize'
class Tile
  attr_reader :value, :hit
  def initialize(value, board, pos)
    @value = value
    @board = board
    @pos = pos
    @hit = false
  end

  def end_tile?
    if @pos[0].between?(0,9) && @pos[1].between(0,9)
      true
    else
      false
    end
  end

  def get_shot
    @hit = true
  end

  def show(own)
    if @hit
      if @value
         "X".colorize(:red)
      else
         "M".colorize(:white)
      end
    else
      if own && @value
         value[0].to_s.colorize(:green)
      else
         "W".colorize(:blue)
      end
    end
  end
end
