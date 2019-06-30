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
end
