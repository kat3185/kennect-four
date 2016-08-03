require "colorize"
require_relative "player"
require_relative "board"
require_relative "diagonals"

class Game
  attr_accessor :first_player, :second_player, :board
  def initialize(first_player_name = String.new, second_player_name = String.new)
    @first_player = Player.new("o".red, first_player_name)
    @second_player = Player.new("o".blue, second_player_name)
    @board = Board.new
    @winner = nil
  end

  def play
    puts "Welcome to Kennect Four!"
    get_names unless is_rematch
    randomize_turns
    until someone_wins! || board.is_full
      puts board.display
      make_move
      change_turn
    end
    announce_results
    play_again?
  end

  def is_rematch
    first_player.name != String.new
  end

  def get_names
    print "First player, please enter your name: "
    first_player.name = get_action
    puts "Excellent!"
    print "Second player, please enter your name: "
    second_player.name = get_action
    while second_player.name == first_player.name
      puts "You can't play yourself!  And we all know that no two people have the same name."
      print "Second player, what's your real name? "
      second_player.name = get_action
    end
    puts "Excellenter!"
  end

  def randomize_turns
    @current_player = (rand(2) == 1 ? first_player : second_player)
    puts "\nMy binary coin toss has determined that #{@current_player.name} will go first!\n\n"
  end

  def make_move
    first_open_space = nil
    until !first_open_space.nil? # until first_open_space is defined
      print "\n#{@current_player.name}, pick a column to drop your piece on (1-7): "
      column = get_action.to_i
      column = validate_column(column)
      first_open_space = validate_move(column)
    end
    board.grid[column][first_open_space] = @current_player.symbol
  end

  def validate_column(column)
    until (1..7).include?(column)
      puts "#{@current_player.name}, that is not a legal move."
      print "Pick a column between 1 and 7 to drop your piece on: "
      column = get_action.to_i
    end
    column - 1
  end

  def validate_move(column)
    desired_move = board.grid[column].find_index { |x| x == " " }
    if desired_move == nil
      puts "Oh no, that column is full! Time to try again."
    end
    desired_move
  end

  def change_turn
    @current_player = @current_player == first_player ? second_player : first_player
  end

  def someone_wins!
    check_for_four(board.all_lines)
  end

  def check_for_four(lines)
    lines.each do |line|
      @winner = first_player if line.include?("o".red*4)
      @winner = second_player if line.include?("o".blue*4)
    end
    @winner != nil
  end

  def announce_results
    puts board.display
    puts @winner.nil? ? "\nIt's a tie! |-o-|" : "\n#{@winner.name} won!  Congrats!"
  end

  def play_again?
    print "\nWould you like to play again? (Y/N) "
    rematch = get_action
    if rematch.downcase == "y"
      puts "Let's get ready to rumblllllllle!"
      rematch = Game.new(first_player.name, second_player.name)
      rematch.play
    else
      puts "Bye now! Have a nice life!"
    end
  end

  def get_action
    gets.chomp
  end
end
