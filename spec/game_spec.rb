require_relative 'spec_helper'

describe Game do
  let!(:game) { Game.new }
  let(:rematch) { Game.new("Ken", "Charlene")}

  describe "#initialize" do
    it "has two players and an empty board" do
      expect(game.first_player).to be_a(Player)
      expect(game.second_player).to be_a(Player)
      expect(game.board).to be_a(Board)
    end
  end
  describe "#is_rematch" do
    it "returns false if the players were initialized with no name" do
      expect(game.is_rematch).to be(false)
    end
    it "returns true if the players were passed a name on game creation" do
      expect(rematch.is_rematch).to be(true)
    end
  end
  describe "#check_for_four" do
    it "returns false if no player has four peices in a row and does not set @winner" do
      expect(game.check_for_four(game.board.all_lines)).to eq(false)
      game.board.grid[0][0] = "o".red
      game.board.grid[0][1] = "o".red
      game.board.grid[0][2] = "o".red
      expect(game.check_for_four(game.board.all_lines)).to eq(false)
      expect(game.instance_variable_get(:@winner)).to eq(nil)
    end
    it "returns true if a player has four peices in a horizontal row and sets @winner" do
      expect(game.check_for_four(game.board.all_lines)).to eq(false)
      game.board.grid[0][0] = "o".red
      game.board.grid[0][1] = "o".red
      game.board.grid[0][2] = "o".red
      game.board.grid[0][3] = "o".red
      expect(game.check_for_four(game.board.all_lines)).to eq(true)
      expect(game.instance_variable_get(:@winner)).to eq(game.first_player)
    end
    it "returns true if a player has four peices in a vertical row and sets @winner" do
      expect(game.check_for_four(game.board.all_lines)).to eq(false)
      game.board.grid[0][0] = "o".red
      game.board.grid[1][0] = "o".red
      game.board.grid[2][0] = "o".red
      game.board.grid[3][0] = "o".red
      expect(game.check_for_four(game.board.all_lines)).to eq(true)
      expect(game.instance_variable_get(:@winner)).to eq(game.first_player)
    end
    it "returns true if a player has four peices in a diagonal row and sets @winner" do
      expect(game.check_for_four(game.board.all_lines)).to eq(false)
      game.board.grid[0][0] = "o".red
      game.board.grid[1][1] = "o".red
      game.board.grid[2][2] = "o".red
      game.board.grid[3][3] = "o".red
      expect(game.check_for_four(game.board.all_lines)).to eq(true)
      expect(game.instance_variable_get(:@winner)).to eq(game.first_player)
    end
    it "returns true if a player has four peices in a reverse diagonal row and sets @winner" do
      expect(game.check_for_four(game.board.all_lines)).to eq(false)
      game.board.grid[4][0] = "o".blue
      game.board.grid[3][1] = "o".blue
      game.board.grid[2][2] = "o".blue
      game.board.grid[1][3] = "o".blue
      expect(game.check_for_four(game.board.all_lines)).to eq(true)
      expect(game.instance_variable_get(:@winner)).to eq(game.second_player)
    end
  end
end
