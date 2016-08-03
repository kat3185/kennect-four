require_relative 'spec_helper'

describe Player do
  let(:luke) { Player.new("o", String.new) }

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
