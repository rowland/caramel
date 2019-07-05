require "xml"
require "./widget"
require "./container"
require "./styles"

module Caramel::Widgets
  alias WidgetMaker = Proc(Container, XML::Node, Widget | Styles)

  class Factory
    class UnregisteredWidget < Exception
    end

    @@registry = Hash(String, WidgetMaker).new

    def self.register(tag : String, &block : WidgetMaker) : Nil
      @@registry[tag] = block
    end

    def self.make(tag : String, parent : Container, node : XML::Node) : Widget | Styles
      if maker = @@registry[tag]?
        maker.call(parent, node)
      else
        raise UnregisteredWidget.new(tag)
      end
    end

    def self.tags : Array(String)
      @@registry.keys
    end
  end

  extend self

  def register(tag : String, &block : WidgetMaker) : Nil
    Factory.register(tag, &block)
  end

  def make(tag : String, parent : Container, node : XML::Node) : Widget | Styles
    Factory.make(tag, parent, node)
  end
end
