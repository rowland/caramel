require "xml"
require "./container"
require "./factory"

module Caramel::Widgets
  class Widget
    getter node : XML::Node

    def initialize(parent : Container, node : XML::Node)
      @node = node
      parent << self unless parent.nil?
    end
  end

  register("widget") { |parent, node| Widget.new(parent, node) }
end
