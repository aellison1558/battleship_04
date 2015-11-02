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

  def cursor_input
  end

  def send_feedback(is_hit, shot)
    if is_hit
      puts "Hit at #{shot}!"
    else
      puts "Miss!"
    end
  end
end

class SimpleComputer
  attr_reader :name
  def initialize(name = "Computer")
    @name = name
    @previous_shots = []
  end

  def get_shot(board)
    random_shot
  end

  def random_shot
    shot = [rand(10), rand(10)]
    while @previous_shots.include?(shot)
      shot = [rand(10), rand(10)]
    end
    @previous_shots << shot
    shot
  end

  def send_feedback(is_hit, shot)
    if is_hit
      puts "Hit at #{shot}!"
    else
      puts "Miss!"
    end
  end
end
