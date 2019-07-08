require "xml"
require "./container"
require "../io"
require "./page"
require "../styles"

module Caramel::Widgets
  class Document < Container
    @custom_tags = {} of String => Hash(String, String)
    @filename = ""
    @pages = [] of Page

    getter pages : Array(Page)

    def initialize
      initialize(XML.parse("<crml />"))
    end

    def initialize(@filename : String)
      File.open(@filename) { |f| initialize(f) }
    end

    def initialize(io : ::IO)
      initialize(XML.parse(io))
    end

    def initialize(node : XML::Node)
      unless node.element?
        unless node = node.first_element_child
          raise "Invalid document"
        end
      end
      Caramel::IO.expand(node, File.dirname(@filename), "styles", "src")
      super(self, node)
      apply_styles
    end

    def apply_styles
      pages.each { |p| p.apply_styles([rule_set]) }
    end

    def <<(object)
      case object
      when Page
        pages << object
      else
        super
      end
    end

    def draw(wr : PDF::Writer)
      wr.open
      pages.each { |p| p.draw(wr) }
      wr.close
    end
  end

  # register("crml") { |parent, node| Document.new(parent, node) }
end
