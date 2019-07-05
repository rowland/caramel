require "xml"
require "./container"
require "./factory"

module Caramel::Widgets
  class Styles
    def initialize(parent : Container, node : XML::Node)
    end
  end

  register("styles") { |parent, node| Styles.new(parent, node) }
end
