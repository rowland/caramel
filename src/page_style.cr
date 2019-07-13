module Caramel
  class PageStyle
    @height : Float64 | Nil
    @width : Float64 | Nil

    property orientation : String
    property size : String

    def initialize(@size : String = PDF::PS_DEFAULT, @orientation : String = "portrait")
    end

    def height : Float64
      w, h = PDF::PAGE_SIZES[size]? || PDF::PAGE_SIZES[PDF::PS_DEFAULT]
      @height || (landscape ? w : h)
    end

    def height=(@height : Float64)
    end

    def landscape : Bool
      orientation == "landscape"
    end

    def width : Float64
      w, h = PDF::PAGE_SIZES[size]? || PDF::PAGE_SIZES[PDF::PS_DEFAULT]
      @width || (landscape ? h : w)
    end

    def width=(@width : Float64)
    end
  end
end
