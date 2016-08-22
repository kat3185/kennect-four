class Slot
  attr_accessor :content
  def initialize(content = " ")
    @content = content
  end

  def is_taken?
    content != " "
  end
end
