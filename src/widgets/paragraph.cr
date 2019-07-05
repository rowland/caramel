require "xml"
require "./container"
require "./factory"
require "./widget"

module Caramel::Widgets
  class Paragraph < Widget
    def initialize(parent : Container | Nil = nil, node : XML::Node | Nil = nil)
      super
      if n = node
        n["class"] = String.build do |s|
          s << n["class"]? || ""
          s << " basic-latin"
        end
      end
    end
  end

  register("p") { |parent, node| Paragraph.new(parent, node) }
end
