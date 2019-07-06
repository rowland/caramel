require "./container"
require "./factory"

module Caramel::Widgets
  class Page < Container
    def draw(wr : PDF::Writer)
      wr.open_page
      super
      wr.close_page
    end
  end

  register("page") { |parent, node| Page.new(parent, node) }
end
