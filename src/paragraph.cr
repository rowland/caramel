require "xml"
require "./container"
require "./factory"
require "./widget"

module Caramel
  class Paragraph < Widget
    def initialize(parent : Container, node : XML::Node)
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
