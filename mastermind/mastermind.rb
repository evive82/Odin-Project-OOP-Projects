class Board
  def initialize;
  end

  def show hints, guesses, answers
    system "clear"
    board_template = 
      "\n\n" +
      "o : A color is correct, but in an incorrect place.\n" +
      "* : A correct color is in a correct place.\n\n\n" +
      "   |-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|\n" +
      "   | #{hints[1][0]} #{hints[1][1]} | #{hints[2][0]} #{hints[2][1]} | #{hints[3][0]} #{hints[3][1]} | #{hints[4][0]} #{hints[4][1]} | #{hints[5][0]} #{hints[5][1]} | #{hints[6][0]} #{hints[6][1]} | #{hints[7][0]} #{hints[7][1]} | #{hints[8][0]} #{hints[8][1]} | #{hints[9][0]} #{hints[9][1]} | #{hints[10][0]} #{hints[10][1]} | #{hints[11][0]} #{hints[11][1]} | #{hints[12][0]} #{hints[12][1]} |     |\n" +
      "   | #{hints[1][2]} #{hints[1][3]} | #{hints[2][2]} #{hints[2][3]} | #{hints[3][2]} #{hints[3][3]} | #{hints[4][2]} #{hints[4][3]} | #{hints[5][2]} #{hints[5][3]} | #{hints[6][2]} #{hints[6][3]} | #{hints[7][2]} #{hints[7][3]} | #{hints[8][2]} #{hints[8][3]} | #{hints[9][2]} #{hints[9][3]} | #{hints[10][2]} #{hints[10][3]} | #{hints[11][2]} #{hints[11][3]} | #{hints[12][2]} #{hints[12][3]} |     |\n" +
      "   |-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|\n" +
      " 1 |  #{guesses[1][0]}  |  #{guesses[2][0]}  |  #{guesses[3][0]}  |  #{guesses[4][0]}  |  #{guesses[5][0]}  |  #{guesses[6][0]}  |  #{guesses[7][0]}  |  #{guesses[8][0]}  |  #{guesses[9][0]}  |  #{guesses[10][0]}  |  #{guesses[11][0]}  |  #{guesses[12][0]}  |  #{answers[0]}  |\n" +
      " 2 |  #{guesses[1][1]}  |  #{guesses[2][1]}  |  #{guesses[3][1]}  |  #{guesses[4][1]}  |  #{guesses[5][1]}  |  #{guesses[6][1]}  |  #{guesses[7][1]}  |  #{guesses[8][1]}  |  #{guesses[9][1]}  |  #{guesses[10][1]}  |  #{guesses[11][1]}  |  #{guesses[12][1]}  |  #{answers[1]}  |\n" +
      " 3 |  #{guesses[1][2]}  |  #{guesses[2][2]}  |  #{guesses[3][2]}  |  #{guesses[4][2]}  |  #{guesses[5][2]}  |  #{guesses[6][2]}  |  #{guesses[7][2]}  |  #{guesses[8][2]}  |  #{guesses[9][2]}  |  #{guesses[10][2]}  |  #{guesses[11][2]}  |  #{guesses[12][2]}  |  #{answers[2]}  |\n" +
      " 4 |  #{guesses[1][3]}  |  #{guesses[2][3]}  |  #{guesses[3][3]}  |  #{guesses[4][3]}  |  #{guesses[5][3]}  |  #{guesses[6][3]}  |  #{guesses[7][3]}  |  #{guesses[8][3]}  |  #{guesses[9][3]}  |  #{guesses[10][3]}  |  #{guesses[11][3]}  |  #{guesses[12][3]}  |  #{answers[3]}  |\n" +
      "   |-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|" +
      "\n\n(R)ed, (G)reen, (Y)ellow, (O)range, (B)lack, (W)hite\n\n"
    puts board_template
  end
end

class Player
  attr_reader :game

  def initialize game 
    @game = game
  end

  def get_guesses round, place = 1, guesses = []
    guess_array = guesses
    game.show_board
    puts "Pick a color for place ##{place.to_s}:"
    guess = gets.chomp.upcase
    until ['R', 'G', 'Y', 'O', 'B', 'W'].include?(guess)
      puts "Invalid selection. Try again."
      guess = gets.chomp.upcase
    end
    guess_array.push(guess)
    if place < 4
      self.get_guesses(round, place + 1, guess_array)
    else
      game.submit_guesses(guess_array, round)
    end
  end
end

class Game
  attr_reader :game_running

  def initialize
    @game_running = true
    @answer = ['R', 'G', 'Y', 'O', 'B', 'W'].shuffle[0..3]
    @board = Board.new
    @hint_display = Hash.new([' ', ' ', ' ', ' '])
    @guess_display = Hash.new([' ', ' ', ' ', ' '])
    @answer_display = ['?', '?', '?', '?']
  end

  def show_board
    @board.show(@hint_display, @guess_display, @answer_display)
  end

  def submit_guesses guesses, round
    @guess_display[round] = guesses
    @hint_display[round] = self.get_hints(guesses)
    if guesses == @answer
      @game_running = false
      @answer_display = @answer
      self.show_board
      puts "You win!"
    elsif round == 12
      @game_running = false
      @answer_display = @answer
      self.show_board
      puts "Sorry, you ran out of turns."
    else
      self.show_board
    end
    puts @hints
  end

  def get_hints guesses
    hints = []
    @answer.each_with_index do |v, i|
      if guesses[i] == v
        hints[i] = '*'
      elsif guesses.include?(v)
        hints[i] = 'o'
      else
        hints[i] = ' '
      end
    end
    hints.sort
  end
end

def game_menu
  system "clear"
  message = "Welcome to Mastermind! Would you like to be the codebreaker " +
            "or the codemaker?\n\n" +
            "(1) Codebreaker\n" +
            "(2) Codemaker\n" +
            "(3) Exit"
  puts message
  choice = gets.chomp.to_i
  if choice == 1
    play_game
  elsif choice == 2
    play_game
  elsif choice == 3
    return
  else
    game_menu
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

def play_game
  game = Game.new
  player = Player.new(game)
  game.show_board
  round_counter = 1
  while game.game_running do
    player.get_guesses(round_counter)
    round_counter += 1
  end
  game_menu if play_again
end

game_menu