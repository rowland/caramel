require "pdf"
require "xml"
require "./abstract_widget"
require "./container"
require "./factory"
require "./xml"

module Caramel
  class Widget < AbstractWidget
    @parent : Container | Nil

    getter node : XML::Node

    def initialize(@parent : Container, @node : XML::Node)
      parent << self
    end

    def apply_styles(rule_sets : Array(Caramel::RuleSet))
      overrides = node.attributes.to_h
      if custom_attrs = custom_tags[node.name]?
        node.attributes.merge!(custom_attrs.reject("tag"))
      end
      rule_sets.each do |rule_set|
        rule_set.each do |rule|
          node.attributes.merge!(rule.attrs) if rule.match?(node.path)
        end
      end
      node.attributes.merge!(overrides)
    end

    @attributes : Attributes | Nil

    protected def attributes : Attributes
      @attributes ||= self.node.attributes.to_h
    end

    def custom_tags
      parent.custom_tags
    end

    def draw(wr : PDF::Writer)
    end

    def parent : Container
      @parent || raise "No parent"
    end

    def set_attributes
    end

    @units : String | Nil

    def units
      @units ||= attributes["units"]? || parent.units
    end
  end

  Factory.register("widget") { |parent, node| Widget.new(parent, node) }
end
