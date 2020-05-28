class Board
  attr_accessor :message, :board, :available_moves

  def initialize
    @board = {}
    9.times { |i| @board[i + 1] = " " }
    @message = ""
    @available_moves = (1..9).to_a
  end

  def show_board
    system "clear"
    board_template =
      " \n\n" +
      "Enter the number for the corresponding square\n" +
      "that you would like to place your marker in:\n\n" +
      " _________________ \n" +
      "|     |     |     |    ___________\n" +
      "|  #{@board[7]}  |  #{@board[8]}  |  #{@board[9]}  |   |_7_|_8_|_9_|\n" +
      "|_____|_____|_____|   |_4_|_5_|_6_|\n" +
      "|     |     |     |   |_1_|_2_|_3_|\n" +
      "|  #{@board[4]}  |  #{@board[5]}  |  #{@board[6]}  |\n" +
      "|_____|_____|_____|   #{@message}\n" +
      "|     |     |     |\n" +
      "|  #{@board[1]}  |  #{@board[2]}  |  #{@board[3]}  |\n" +
      "|_____|_____|_____|\n\n" +
      " "
    puts board_template
  end
end

class Game
  attr_reader :game_running, :board

  def initialize(board)
    @game_running = true
    @board = board
  end

  def check_for_win xo
    wins = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7]
    ]
    wins.each do |a|
      if a.select { |i| @board.board[i].include?(xo) }.length == 3
        @board.message = "#{xo} wins!"
        @board.show_board
        @game_running = false
        break
      end
    end
    if !@board.message.include?("wins") && @board.available_moves.length < 1
      @board.message = "It's a tie!"
      @board.show_board
      @game_running = false
    end
  end
end

class Player
  attr_reader :xo, :game

  def initialize player_num, game
    @xo = player_num == 1 ? 'X' : 'O'
    @game = game
  end

  def get_move
    puts "Player #{xo}, enter your move."
    place = gets.chomp.to_i
    while place < 1 || place > 9
      puts "Must be a number between 1 and 9"
      place = gets.chomp.to_i
    end
    place
  end

  def place_move
    if game.game_running
      place = self.get_move
      if game.board.available_moves.include?(place)
        game.board.board[place] = xo
        game.board.available_moves.delete(place)
        game.board.message = ""
        game.check_for_win(xo)
      elsif !game.board.available_moves.include?(place) 
        game.board.message = "Invalid placement"
        game.board.show_board
        self.place_move
      end
    end
    game.board.show_board
  end
end

def play_again
  puts "Would you like to play again? (y/n)"
  again = gets.chomp
  while again.downcase != "y" && again.downcase != "n"
    puts "Would you like to play again? (y)es or (n)o."
    again = gets.chomp
  end
  return again.downcase == "y" ? true : false
end

def run_game
  board = Board.new
  game = Game.new(board)
  player1 = Player.new(1, game)
  player2 = Player.new(2, game)
  
  game.board.show_board

  while game.game_running do
    player1.place_move
    player2.place_move
  end
  run_game if play_again
end

run_game