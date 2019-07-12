require "./container"
require "./factory"

module Caramel
  class Page < Container
    def draw(wr : PDF::Writer)
      wr.open_page
      super
      wr.close_page
    end
  end

  Factory.register("page") { |parent, node| Page.new(parent, node) }
end
