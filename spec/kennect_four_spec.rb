require "rspec"
require_relative "../lib/game"

"User Stories

Prompt for player's names

id: connect4-1

  As a player
  I want to enter my name
  So that I can be identified throughout the game
Acceptance Criteria:

[x] Each player can enter their name
[x] The game cannot proceed until they each specify a name
[x] Each name must be unique


Player to select a column

As a player
I want to drop a piece in a column
So that I can attempt to win the game
id: connect4-2

Acceptance Criteria:

[x] The player must specify a valid column. If they provide something invalid, inform them they must select a valid column and do not drop a game piece
[x] When the player specifies a valid column, place their respective game piece in the first available row in that column.
[x] When the player specifies a valid column, it becomes the next players turn.


Player selects a column that is full

id: connect4-3

As a player
I want to know I cannot drop a piece in a full column
So that I can make an effective move
Acceptance Criteria:

[x] When a player selects a column that is full of game pieces (there is no available row), they are told that the column is full and they are prompted to select another column.


Player wins game

id: connect4-4

As a player
I want to know I've won the game
So that I can feel accomplished in my victory
Acceptance Criteria:

[x] Upon their turn, if a player drops a piece that makes a vertical or horizontal line of 4 of their pieces consecutively, they have won the game and the game is over.
[x] Inform the player of their victory, and ask if they want to play again
[x] If they want to play again, keep the same players but clear the game board.


Stalemate

As a player
I want to know the game is over when the board is full
So we know the game has ended in a draw
Acceptance Criteria:

[x] When the board is full, meaning all rows and columns are occupied, the game is at a stalemate, resulting in a draw.
[x] Inform the users that the game is a draw, and ask if they want to play again
[x] If they want to play again, keep the same players but clear the game board."

describe Player do
  let(:luke) { Player.new("o") }

  describe "#initialize" do
    it "has a name" do
      expect(luke.name).to eq("")
      luke.name = "Luke"
      expect(luke.name).to eq("Luke")
    end
    it "takes a symbol input" do
      expect(luke.symbol).to eq("o")
    end
  end
end

describe Board do
  describe "#initialize" do
    board = Board.new
    it "is a 6 by 7 two dimentional array" do
      expect(board.grid).to be_an(Array)
      expect(board.grid.first).to be_an(Array)
    end
  end
end

describe Game do
  let(:game) { Game.new }

  describe "#initialize" do
    it "has a board and players" do
      expect(game.board).to be_a(Board)
      expect(game.first_player).to be_a(Player)
    end
  end

  describe "#is_rematch" do
    it "remembers previous names" do
      game1 = Game.new("MLG", "DRod")
      expect(game1.is_rematch).to be(true)
      expect(game1.first_player.name).to eq("MLG")
      expect(game1.second_player.name).to eq("DRod")
    end
  end

  describe "#get_names" do
    it "gets the players names" do
      allow(game).to receive(:gets).and_return("Christina", "Richard")
      game.get_names
      expect(game.first_player.name).to eq("Christina")
    end

    it "doesn't want the same player name twice" do
      allow(game).to receive(:gets).and_return("DT", "DT", "Jarvis")
      #without the third input of "Jarvis", this test causes an infinte loop
      #as it should
      game.get_names
      expect(game.first_player.name).to eq("DT")
      expect(game.second_player.name).to eq("Jarvis")
    end
  end

  describe "#randomize_turns" do
    it "randomizes which player goes first" do
      turns = Array.new
      10.times do
        game.randomize_turns
        turns << @current_player
      end
      expect(turns).to include(@first_player)
      expect(turns).to include(@second_player)
    end
  end

  describe "#make_move" do
    it "changes a symbol in the grid" do
      game.first_player.name = "Jarvis"
      game.second_player.name = "Elise"
      game.current_player = game.first_player
      allow(game).to receive(:gets).and_return("4")
      game.make_move
      expect(game.board.grid.flatten.join).to include("\e[0;31;49mo\e[0m")
    end
  end

  describe "#validate_column" do
    it "checks that the player picked a valid column" do
      game.first_player.name = "Jarvis"
      game.second_player.name = "Elise"
      game.randomize_turns
      expect(game.validate_column(4)).to eq(4)
    end

    it "won't accept invalid columns" do
      game.first_player.name = "Jarvis"
      game.second_player.name = "Elise"
      game.randomize_turns
      allow(game).to receive(:gets).and_return("The Dark Side", "4")
      expect(game.validate_column(9)).to eq(4)
    end
  end

  describe "#validate_move" do
    it "#won't let you select an already full column" do
      game.first_player.name = "Jarvis"
      game.second_player.name = "Elise"
      game.current_player = game.second_player
      allow(game).to receive(:gets).and_return("4", "4", "4", "4", "4", "4", "4", "5")
      #tries to make eight moves
      7.times do
        game.make_move
      end
      #expects seven moves to have been made, despite eight being input
      expect(game.board.grid.flatten.join).to include("\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m")
      expect(game.board.grid.flatten.join).to_not include("\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo\e[0m\e[0;34;49mo")
    end
  end

  describe "#change_turn" do
    it "changes the current player" do
      game.first_player.name = "Jarvis"
      game.second_player.name = "Elise"
      game.current_player = game.second_player
      game.change_turn
      expect(game.current_player).to eq(game.first_player)
    end
  end

  describe "check columns for four" do
    it "returns false if noone has won" do
      expect(game.check_board_for_four([board.grid])).to be(false)
    end

    it "sets first player to winner if they have four adjacent peices in a column" do
      game.board.grid[0][0] = "o".red
      game.board.grid[0][1] = "o".red
      game.board.grid[0][2] = "o".red
      game.board.grid[0][3] = "o".red
      expect(game.check_board_for_four([board.grid])).to be(true)
      expect(game.winner).to eq(game.first_player)
    end

    it "sets second player to winner if they have four adjacent peices in a column" do
      game.board.grid[0][0] = "o".blue
      game.board.grid[0][1] = "o".blue
      game.board.grid[0][2] = "o".blue
      game.board.grid[0][3] = "o".blue
      expect(game.check_board_for_four([board.grid])).to be(true)
      expect(game.winner).to eq(game.second_player)
    end
  end

  describe "check rows for four" do
    it "returns false if noone has won" do
      game.board.grid[0][0] = "o".red
      game.board.grid[1][0] = "o".red
      game.board.grid[2][0] = "o".red
      game.board.grid[4][0] = "o".red
      expect(game.check_board_for_four([board.grid.transpose])).to be(false)
    end

    it "sets first player to winner if they have four adjacent pieces in a row" do
      game.board.grid[0][0] = "o".red
      game.board.grid[1][0] = "o".red
      game.board.grid[2][0] = "o".red
      game.board.grid[3][0] = "o".red
      expect(game.check_board_for_four([board.grid.transpose])).to be(true)
      expect(game.winner).to eq(game.first_player)
    end

    it "sets first player to winner if they have four pieces in a row" do
      game.board.grid[0][0] = "o".blue
      game.board.grid[1][0] = "o".blue
      game.board.grid[2][0] = "o".blue
      game.board.grid[3][0] = "o".blue
      expect(game.check_board_for_four([board.grid.transpose])).to be(true)
      expect(game.winner).to eq(game.second_player)
    end
  end

  describe "#check_diagonals_for_four" do
    it "returns false if noone has won" do
      game.board.grid[0][0] = "o".red
      game.board.grid[1][0] = "o".red
      game.board.grid[2][0] = "o".red
      game.board.grid[4][0] = "o".red
      expect(game.check_board_for_four([raw_left_diagonals])).to be(false)
    end

    it "sets first player to winner if they have four adjacent pieces in a row" do
      game.board.grid[0][0] = "o".red
      game.board.grid[1][1] = "o".red
      game.board.grid[2][2] = "o".red
      game.board.grid[3][3] = "o".red
      expect(game.check_board_for_four([raw_right_diagonals])).to be(true)
      expect(game.winner).to eq(game.first_player)
    end

    it "sets first player to winner if they have four pieces in a row" do
      game.board.grid[2][3] = "o".blue
      game.board.grid[3][2] = "o".blue
      game.board.grid[4][1] = "o".blue
      game.board.grid[5][0] = "o".blue
      expect(game.check_board_for_four([raw_left_diagonals])).to be(true)
      expect(game.winner).to eq(game.second_player)
    end
  end
end
