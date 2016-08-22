require_relative 'spec_helper'

describe Slot do
  let(:slot) { Slot.new }

  describe "#initialize" do
    it "has content" do
      expect(slot.content).to eq(" ")
      slot.content = "o"
      expect(slot.content).to eq("o")
    end
  end
  describe "#is_taken?" do
    it 'returns false if content has not been altered' do
      expect(slot.is_taken?).to eq(false)
    end
    it 'returns true if content is anything but a string with a space' do
      slot.content = "o"
      expect(slot.is_taken?).to eq(true)
    end
  end
end
