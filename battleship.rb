require_relative "board"
require_relative "player"
require_relative 'display'
require "colorize"
require "yaml"
class Game
  attr_reader :board1, :board2, :player1, :player2, :current, :other
  def initialize(board1, board2, player1, player2)
    @player1 = {board: board1, player: player1}
    @player2 = {board: board2, player: player2}
    @current = @player1
    @other = @player2
    @display = Display.new(@current[:board])
  end

  def play
    start_game
    until game_over?
      render_boards
      play_turn
      switch_players!
    end

    puts "Game Over!"
    puts "#{winner} won!"
  end

  def start_game
    puts "Welcome to Battleship!"
    input = ""
    until input == 'N' || input == 'L'
      puts "Type 'N' to start a new game or 'L' to load a previous game "
      input = gets.chomp.upcase
      if input == 'L'
        load_game
      end
    end
  end

  def game_over?
    @other[:board].all_ships_sunk?
  end

  def load_game
    saved_game = YAML.load_file("save.yml")
    @player1 = saved_game.player1
    @player2 = saved_game.player2
    @current = saved_game.current
    @other = saved_game.other
  end

  def save_game
    File.open("save.yml", "w") do |f|
      f.puts self.to_yaml
    end
  end

  def render_boards
    system("clear")
    @display.update_board(@other[:board])
    @display.render
    puts "-----------------------"
    @display.update_board(@current[:board])
    @display.render_own
  end

  def play_turn
    shot = nil
    if @current[:player].is_a?(HumanPlayer)
      until shot
        shot = @display.get_input
        render_boards
      end
    else
      shot = @current[:player].get_shot(@other[:board])
    end
    if shot == "s"
      save_game
      puts "Game saved! Input coordinates to continue"
      shot = @current[:player].get_shot(@other[:board])
    end
    is_hit = @other[:board].shoot_at(shot)
    # new_tile = @other[:board].update_tile(shot, is_hit)
    @current[:player].send_feedback(is_hit, shot)
  end

  def switch_players!
    if @current == @player1
      @current = @player2
      @other = @player1
    else
      @current = @player1
      @other = @player2
    end
  end

  def winner
    @current[:player].name
  end
end

player1 = HumanPlayer.new("Andrew")
player2 = SimpleComputer.new
board1 = Board.new
board2 = Board.new
game = Game.new(board1, board2, player1, player2)
game.play
