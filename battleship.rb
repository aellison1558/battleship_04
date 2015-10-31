
class Game

  def initialize(board1, board2, player1, player2)
    @player1 = {board: board1, player: player1}
    @player2 = {board: board2, player: player2}
    @current = @player1
    @other = @player2
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
    saved_game = YAML.load("save.yml")
    @player1 = saved_game.player1
    @player2 = saved_game.player2
    @current = saved_game.current
    @other = saved_game.current
  end

  def render_boards
    system("clear")
    @other[:board].render
    @current[:board].render_own
  end

  def play_turn
    shot = @current[:player].get_shot
    is_hit = @other[:board].shoot_at(shot)
    new_tile = @other[:board].update_tile(shot, is_hit)
    @current[:player].send_feedback(is_hit, new_tile)
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
