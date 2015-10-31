class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_shot(board)
    input = nil
    valid_coordinates = nil
    until valid_coordinates
      puts "Input shot coordinates (row,col) (or type 's' to save)"
      input = gets.chomp
      return input if input == 's'
      input = input.split(",")
      valid_coordinates = input.all? {|coord| coord.between?("0", "9")}
    end
    input.map {|coord| coord.to_i}
  end

  def send_feedback(is_hit, new_tile)
    if is_hit
      puts "Hit at #{new_tile.position}!"
    else
      puts "Miss!"
    end
  end
end
