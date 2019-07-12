require "xml"
require "./abstract_widget"
require "./container"

module Caramel
  alias WidgetMaker = Proc(Container, XML::Node, AbstractWidget)

  class Factory
    class UnregisteredWidget < Exception
    end

    @@registry = Hash(String, WidgetMaker).new

    def self.register(tag : String, &block : WidgetMaker) : Nil
      @@registry[tag] = block
    end

    def self.make(tag : String, parent : Container, node : XML::Node) : AbstractWidget
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
end
