require "xml"
require "./container"
require "./page"
require "../styles"

module Caramel::Widgets
  class Document < Container
    @pages = Array(Page).new

    getter pages : Array(Page)

    def initialize
      @node = XML.parse("<crml />")
    end

    def initialize(filename : String)
      File.open(filename) { |f| initialize(f) }
    end

    def initialize(io : ::IO)
      if node = XML.parse(io).first_element_child
        initialize(node)
      else
        raise "Invalid document"
      end
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
