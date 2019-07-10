require "xml"
require "./abstract_widget"
require "./container"
require "./factory"

module Caramel::Widgets
  class CustomTag < AbstractWidget
    def initialize(parent : Container, node : XML::Node)
      attrs = node.attributes.to_h
      if id = attrs.delete("id")
        parent.custom_tags[id] = attrs
      end
    end
  end

  register("define") { |parent, node| CustomTag.new(parent, node) }
end
