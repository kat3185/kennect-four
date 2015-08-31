require "colorize"
require_relative "player"
require_relative "board"

class Game
  attr_accessor :first_player, :second_player, :current_player, :winner, :board
  def initialize(player1 = nil, player2 = nil)
    @first_player = Player.new("o".red)
    @second_player = Player.new("o".blue)
    @board = Board.new
    @turn_count = 1
    @winner = nil
    @player_names = [player1, player2]
    @current_player = nil
  end

  def play
    puts "Welcome to Kennect Four!"
    get_names unless is_rematch
    randomize_turns
    until someone_wins! || @turn_count == 43
      board.print_board
      make_move
      change_turn
      @turn_count += 1
    end
    announce_results
    play_again?
  end

  def is_rematch
    if @player_names != Array.new(2)
      @first_player.name = @player_names[0]
      @second_player.name = @player_names[1]
      puts "#{@first_player.name} vs #{@second_player.name}... FIGHT!"
      true
    end
    @player_names != Array.new(2)
  end

  def get_names
    print "First player, please enter your name: "
    @first_player.name = get_action
    puts "Excellent!"
    print "Second player, please enter your name: "
    @second_player.name = get_action
    while @second_player.name == @first_player.name
      puts "You can't play yourself!  And we all know that no two people have the same name."
      print "Second player, what's your real name? "
      @second_player.name = get_action
    end
    puts "Excellenter!"
  end

  def randomize_turns
    @current_player = (rand(2) == 1 ? @first_player : @second_player)
    puts "\nMy binary coin toss has determined that #{@current_player.name} will go first!\n\n"
  end

  def make_move
    row = nil
    until row != nil
      print "\n#{@current_player.name}, pick a column to drop your piece on (1-7): "
      column = get_action.to_i
      column = validate_column(column)
      column -= 1
      row = validate_move(column)
    end
    @board.grid[column][row] = @current_player.symbol
  end

  def validate_column(column)
    until (1..7).include?(column)
      puts "#{@current_player.name}, that is not a legal move."
      print "Pick a column between 1 and 7 to drop your piece on: "
      column = get_action.to_i
    end
    column
  end

  def validate_move(column)
    desired_move = @board.grid[column].find_index { |x| x == " " }
    if desired_move == nil
      puts "Oh no, that column is full! Time to try again."
    end
    desired_move
  end

  def change_turn
    @current_player = (@current_player == @first_player ? @second_player : @first_player)
  end

  def someone_wins!
    lines_list = [board.grid,
                  board.grid.transpose,
                  board.raw_right_diagonals,
                  board.raw_left_diagonals]
    check_board_for_four(lines_list)
  end

  def check_board_for_four(lines_list)
    array = Array.new
    lines_list.each do |lines|
      lines.each do |line|
        array << line.join
      end
    end
    check_for_four(array)
  end

  def check_for_four(columns)
    red_score = Array.new
    blue_score = Array.new
    columns.each do |column|
      red_score << column.include?("o".red*4)
      blue_score << column.include?("o".blue*4)
    end
    @winner = @first_player if red_score.include?(true)
    @winner = @second_player if blue_score.include?(true)
    @winner != nil #returns false if no winner
  end

  def announce_results
    board.print_board
    if @winner != nil
      puts "\n#{@winner.name} won!  Congrats!"
    else
      puts "\nIt's a tie! |-o-|"
    end
  end

  def play_again?
    print "\nWould you like to play again? (Y/N) "
    rematch = get_action
    if rematch.downcase == "y"
      puts "Let's get ready to rumblllllllle!"
      rematch = Game.new(@first_player.name, @second_player.name)
      rematch.play
    else
      puts "Bye now! Have a nice life!"
    end
  end

  def get_action
    gets.chomp
  end
end
