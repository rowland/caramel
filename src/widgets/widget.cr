require "pdf"
require "xml"
require "./container"
require "./factory"
require "../xml"

module Caramel::Widgets
  class Widget
    @attributes = {} of String => String
    @parent : Container | Nil

    getter attributes
    getter node : XML::Node

    def initialize(@parent : Container, @node : XML::Node)
      attributes.merge!(@node.attributes.to_h)
      parent << self
    end

    def apply_styles(rule_sets : Array(Caramel::Styles::RuleSet))
      overrides = node.attributes.to_h
      if custom_attrs = custom_tags[node.name]?
        # custom_tag = custom_attrs["tag"]?
        node.attributes.merge!(custom_attrs.reject("tag"))
      end
      rule_sets.each do |rule_set|
        rule_set.each do |rule|
          # puts "#{node.path} matches #{rule.selector} with #{rule.attrs}" if rule.match?(node.path)
          node.attributes.merge!(rule.attrs) if rule.match?(node.path)
        end
      end
      node.attributes.merge!(overrides)
    end

    def custom_tags
      parent.custom_tags
    end

    def parent : Container
      @parent || raise "No parent"
    end

    def draw(wr : PDF::Writer)
    end
  end

  register("widget") { |parent, node| Widget.new(parent, node) }
end
