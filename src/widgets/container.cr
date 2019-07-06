require "xml"
require "./factory"
require "./widget"

module Caramel::Widgets
  class Container < Widget
    @widgets = Array(Widget).new

    getter widgets : Array(Widget)

    def initialize(parent : Container, node : XML::Node)
      super
      node.children.each do |n|
        Caramel::Widgets.make(n.name, self, n) if n.element?
      end
    end

    def <<(object)
      case object
      when Widget
        widgets << object
      end
    end

    def draw(wr : PDF::Writer)
      widgets.each { |w| w.draw(wr) }
      super
    end
  end

  register("div") { |parent, node| Container.new(parent, node) }
end
