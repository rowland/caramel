require "xml"
require "./container"
require "./factory"

module Caramel::Widgets
  class Widget
    getter node : XML::Node | Nil

    def initialize(parent : Container | Nil = nil, node : XML::Node | Nil = nil)
      @node = node
      parent << self unless parent.nil?
    end
  end

  register("widget") { |parent, node| Widget.new(parent, node) }
end
