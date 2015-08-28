class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(7) { Array.new(6, " ") }
  end
end
