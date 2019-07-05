require "./container"
require "./factory"

module Caramel::Widgets
  class Page < Container
  end

  register("page") { |parent, node| Page.new(parent, node) }
end
