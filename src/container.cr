require "xml"
require "./factory"
require "./rule_set"
require "./widget"
require "./xml"
require "./io"

module Caramel
  class Container < Widget
    @custom_tags : Hash(String, Hash(String, String))
    @rule_set = Caramel::RuleSet.new
    @widgets = [] of Widget

    getter custom_tags
    getter rule_set
    getter widgets

    def initialize(parent : Container, node : XML::Node)
      super
      @custom_tags = parent.custom_tags.dup
      node.children.each do |n|
        make(n.name, self, n) if n.element?
      end
    end

    def <<(object)
      case object
      when Widget
        widgets << object
      end
    end

    def apply_styles(rule_sets : Array(Caramel::RuleSet))
      rule_sets.push(rule_set)
      super(rule_sets)
      widgets.each { |w| w.apply_styles(rule_sets) }
      rule_sets.pop
    end

    def draw(wr : PDF::Writer)
      widgets.each { |w| w.draw(wr) }
      super
    end

    protected def make(tag : String, parent : Container, node : XML::Node)
      if attrs = @custom_tags[tag]?
        tag = attrs["tag"]? || tag
      end
      Caramel.make(tag, parent, node)
    end
  end

  register("div") { |parent, node| Container.new(parent, node) }
end
