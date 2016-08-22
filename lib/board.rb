class Board
  attr_accessor :grid
  def initialize(slot = nil)
    @grid = Array.new(7) { Array.new(6) { slot || Slot.new } }
  end

  def printable_grid
    grid.transpose.reverse
  end

  def all_lines
    rows + columns + diagonals
  end

  def is_full
    !grid.flatten.any? { |slot| !slot.is_taken? }
  end

  def display #prints a heredoc showing the board.
    printable_board = "===============================\n"
    printable_grid.each do |row|
      printable_row = "||"
      row.each do |slot|
        printable_row += " #{slot.content} |"
      end
      printable_row += "|\n-------------------------------\n"
      printable_board += printable_row
    end
    printable_board += "===============================\n"
    printable_board += "   1   2   3   4   5   6   7"
    printable_board
  end

  private
  def rows
    grid.transpose.map { |row| row.map { |slot| slot.content }.join }
  end

  def columns
    grid.map { |column| column.map { |slot| slot.content }.join }
  end

  def diagonals
    grid.diagonals.map { |diagonal| diagonal.map {|slot| slot.content }.join }
  end
end
