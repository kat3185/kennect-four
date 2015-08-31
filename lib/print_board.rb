class PrintBoard

  def initialize(board)
    @board = board
  end

  def print
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

end
