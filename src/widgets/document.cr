require "xml"
require "./container"
require "./page"

module Caramel::Widgets
  class Document < Container
    @pages = Array(Page).new

    getter pages : Array(Page)

    def initialize(filename : String)
      File.open(filename) { |f| initialize(f) }
    end

    def initialize(io : ::IO)
      initialize(XML.parse(io).first_element_child)
    end

    def initialize(node : XML::Node)
      super(self, node)
      Caramel::Styles.apply(node)
    end

    def <<(object)
      case object
      when Page
        pages << object
      else
        super
      end
    end
  end

  # register("crml") { |parent, node| Document.new(parent, node) }
end
