require "xml"

struct XML::Node
  def each(type : XML::Type | Nil = nil, name : String | Nil = nil, &block : XML::Node ->)
    if (type == nil || type == self.type) &&
       (name == nil || name == self.name)
      yield self
    end
    self.children.each do |child|
      child.each(type, name, &block)
    end
  end

  def selector_tag : String
    if self.type == XML::Type::ELEMENT_NODE
      String.build do |s|
        s << self.name
        if id = self["id"]?
          s << "#" << id
        end
        if klass = self["class"]?
          s << "." << klass.split.join(".")
        end
      end
    else
      ""
    end
  end

  def path : String
    @path ||= begin
      if p = self.parent
        "#{p.path}/#{selector_tag}"
      else
        selector_tag
      end
    end
  end
end
