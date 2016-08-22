require_relative 'spec_helper'

class Board
  public :rows, :columns, :diagonals
end

describe Board do
  let!(:board) { Board.new }
  describe "#initialize" do
    it "is a 7 by 6 two dimentional array" do
      expect(board.grid.length).to eq(7)
      expect(board.grid.first.length).to eq(6)
    end
  end
  describe "#printable_grid" do
    it "returns a 6 by 7 two dimentional array" do
      expect(board.printable_grid.length).to eq(6)
      expect(board.printable_grid.first.length).to eq(7)
    end
  end
  describe "#rows" do
    it "returns an array of strings representing the rows" do
      expect(board.rows.count).to eq(6)
    end
  end
  describe "#columns" do
    it "returns an array of strings representing the columns" do
      expect(board.columns.count).to eq(7)
    end
  end
  describe "#diagonals" do
    it "returns an array of strings representing the diagonals" do
      expect(board.diagonals.count).to eq(20)
    end
  end
  describe "#all_lines" do
    it "returns an array of strings representing the all of the rows, columns and diagonals" do
      expect(board.all_lines.count).to eq(33)
    end
  end
  describe "#is_full" do
    let(:full_board) { Board.new(Slot.new("o")) }
    it "returns false if the board has any empty spaces left" do
      expect(board.is_full).to be(false)
    end
    it "returns true if the board has no empty spaces left" do
      expect(full_board.is_full).to be(true)
    end
  end
end
