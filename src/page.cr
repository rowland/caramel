require "./container"
require "./factory"
require "./page_style"

module Caramel
  class Page < Container
    def draw(wr : PDF::Writer)
      options = PDF::Options{
        "page_height" => style.height,
        "page_width"  => style.width,
      }
      # puts options
      wr.open_page(options)
      super
      wr.close_page
    end

    def document : Document
      @parent.as(Document)
    end

    @page_style : PageStyle | Nil

    def style : PageStyle
      @page_style ||= document.page_style.dup
    end

    def set_attributes
      if size = attributes["size"]?
        self.style.size = size
      end
      if orientation = attributes["orientation"]?
        self.style.orientation = orientation
      end
      if height = self.attributes.measurement("height", units)
        self.style.height = height
      end
      if width = self.attributes.measurement("width", units)
        self.style.width = width
      end

      super
    end
  end

  Factory.register("page") { |parent, node| Page.new(parent, node) }
end
