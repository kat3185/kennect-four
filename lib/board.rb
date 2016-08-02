class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(7) { Array.new(6, " ") }
  end
  def total_spaces
    grid.flatten.count
  end
  def printable_grid
    grid.transpose.reverse
  end
  def rows
    grid.transpose.map { |row| row.join }
  end
  def columns
    grid.map { |column| column.join }
  end
  def diagonals
    grid.diagonals
  end
  def full?
    !grid.flatten.include?(" ")
  end
  def display #prints a heredoc showing the board.
    printable_board = "===============================\n"
    printable_grid.each do |row|
      printable_row = "||"
      row.each do |space|
        printable_row += " #{space} |"
      end
      printable_row += "|\n-------------------------------\n"
      printable_board += printable_row
    end
    printable_board += "===============================\n"
    printable_board += "   1   2   3   4   5   6   7"
    puts printable_board
  end
end
