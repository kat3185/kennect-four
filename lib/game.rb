require "colorize"
require_relative "player"
require_relative "board"

class Game
  attr_accessor :first_player, :second_player, :current_player, :winner, :board
  def initialize(player1 = nil, player2 = nil)
    @first_player = Player.new("o".red)
    @second_player = Player.new("o".blue)
    @board = Board.new
    @turn_count = 0
    @winner = nil
    @player_names = [player1, player2]
    @current_player = nil
  end

  def play
    puts "Welcome to Kennect Four!"
    get_names unless is_rematch
    randomize_turns
    until someone_wins! || @turn_count == 42
      show_board
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

  def show_board #prints a heredoc showing the board.
    puts <<-eos
   ===============================
   || #{@board.grid[0][5]} | #{@board.grid[1][5]} | #{@board.grid[2][5]} | #{@board.grid[3][5]} | #{@board.grid[4][5]} | #{@board.grid[5][5]} | #{@board.grid[6][5]} ||
   -------------------------------
   || #{@board.grid[0][4]} | #{@board.grid[1][4]} | #{@board.grid[2][4]} | #{@board.grid[3][4]} | #{@board.grid[4][4]} | #{@board.grid[5][4]} | #{@board.grid[6][4]} ||
   -------------------------------
   || #{@board.grid[0][3]} | #{@board.grid[1][3]} | #{@board.grid[2][3]} | #{@board.grid[3][3]} | #{@board.grid[4][3]} | #{@board.grid[5][3]} | #{@board.grid[6][3]} ||
   -------------------------------
   || #{@board.grid[0][2]} | #{@board.grid[1][2]} | #{@board.grid[2][2]} | #{@board.grid[3][2]} | #{@board.grid[4][2]} | #{@board.grid[5][2]} | #{@board.grid[6][2]} ||
   -------------------------------
   || #{@board.grid[0][1]} | #{@board.grid[1][1]} | #{@board.grid[2][1]} | #{@board.grid[3][1]} | #{@board.grid[4][1]} | #{@board.grid[5][1]} | #{@board.grid[6][1]} ||
   -------------------------------
   || #{@board.grid[0][0]} | #{@board.grid[1][0]} | #{@board.grid[2][0]} | #{@board.grid[3][0]} | #{@board.grid[4][0]} | #{@board.grid[5][0]} | #{@board.grid[6][0]} ||
   ===============================
      1   2   3   4   5   6   7
    eos
  end

  def change_turn
    @current_player = (@current_player == @first_player ? @second_player : @first_player)
  end

  def someone_wins!
    check_columns_for_four || check_rows_for_four || check_diagonals_for_four
  end

  def check_columns_for_four
    columns = Array.new
    @board.grid.each do |column|
      columns << column.join
    end
    check_for_four(columns)
  end

  def check_rows_for_four
    rows = Array.new
    @board.grid.transpose.each do |row|
      rows << row.join
    end
    check_for_four(rows)
  end

  def check_diagonals_for_four
    check_right_diagonals || check_left_diagonals
  end

  def check_right_diagonals
    right_diagonals = Array.new
    raw_right_diagonals = [[@board.grid[0][2], @board.grid[1][3], @board.grid[2][4], @board.grid[3][5]],
    [@board.grid[0][1], @board.grid[1][2], @board.grid[2][3], @board.grid[3][4], @board.grid[4][5]],
    [@board.grid[0][0], @board.grid[1][1], @board.grid[2][2], @board.grid[3][3], @board.grid[4][4], @board.grid[5][5]],
    [@board.grid[1][0], @board.grid[2][1], @board.grid[3][2], @board.grid[4][3], @board.grid[5][4], @board.grid[6][5]],
    [@board.grid[1][2], @board.grid[2][3], @board.grid[3][4], @board.grid[4][5]],
    [@board.grid[2][0], @board.grid[3][1], @board.grid[4][2], @board.grid[5][3], @board.grid[6][4]],
    [@board.grid[3][0], @board.grid[4][1], @board.grid[5][2], @board.grid[6][3]]]

    raw_right_diagonals.each do |diagonal|
      right_diagonals << diagonal.join
    end

    check_for_four(right_diagonals)
  end

  def check_left_diagonals
    left_diagonals = Array.new
    raw_left_diagonals = [[@board.grid[3][0], @board.grid[2][1], @board.grid[1][2], @board.grid[0][3]],
    [@board.grid[4][0], @board.grid[3][1], @board.grid[2][2], @board.grid[1][3], @board.grid[0][4]],
    [@board.grid[5][0], @board.grid[4][1], @board.grid[3][2], @board.grid[2][3], @board.grid[1][4], @board.grid[0][5]],
    [@board.grid[6][0], @board.grid[5][1], @board.grid[4][2], @board.grid[3][3], @board.grid[2][4], @board.grid[1][5]],
    [@board.grid[6][1], @board.grid[5][2], @board.grid[4][3], @board.grid[3][4], @board.grid[4][5]],
    [@board.grid[6][2], @board.grid[6][3], @board.grid[6][4], @board.grid[6][5]]]

    raw_left_diagonals.each do |diagonal|
      left_diagonals << diagonal.join
    end

    check_for_four(left_diagonals)
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
    show_board
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
