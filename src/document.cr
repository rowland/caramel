require "xml"
require "./io"
require "./page"

module Caramel
  class Document < Page
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
      Caramel.expand_node(node, File.dirname(@filename), "styles", "src")
      super(self, node)
      apply_styles
    end

    def apply_styles
      pages.each { |p| p.apply_styles([rule_set]) }
    end

    def <<(object)
      return if object == self
      case object
      when Page
        pages << object
      else
        super
      end
    end

    def draw(wr : PDF::Writer)
      set_attributes
      wr.open
      pages.each { |p| p.draw(wr) }
      wr.close
    end

    def draw(io : IO) : Nil
      wr = PDF::Writer.new
      draw(wr)
      wr.to_s(io)
    end

    def draw : String
      wr = PDF::Writer.new
      draw(wr)
      wr.to_s
    end

    def page_style : PageStyle
      @page_style ||= PageStyle.new(
        attributes["size"]? || PDF::PS_DEFAULT,
        attributes["orientation"]? || "portrait")
    end

    def set_attributes
      super
      pages.each { |p| p.set_attributes }
    end

    def units
      @units ||= attributes["units"]? || "pt"
    end
  end

  # register("crml") { |parent, node| Document.new(parent, node) }
end
