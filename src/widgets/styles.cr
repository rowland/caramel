require "xml"
require "./container"
require "./factory"

module Caramel::Widgets
  class Styles
    def initialize(parent : Container | Nil = nil, node : XML::Node | Nil = nil)
    end
  end

  register("styles") { Styles.new }
end
