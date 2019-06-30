require "xml"
require "./rule"
require "./rule_set"

module Caramel::Styles
  extend self

  def apply(node : XML::Node, rule_sets = [] of RuleSet)
    apply_node(node, rule_sets)
    apply_children(node, rule_sets)
  end

  private def apply_node(node : XML::Node, rule_sets : Array(RuleSet))
    overrides = node.attributes.reduce(Hash(String, String).new) do |m, attr|
      m[attr.name] = attr.text
      m
    end
    rule_sets.each do |rule_set|
      rule_set.each do |rule|
        rule.attrs.each do |key, value|
          node.attributes[key] = value if rule.selector == node.name
        end
      end
    end
    overrides.each do |key, value|
      node.attributes[key] = value
    end
  end

  private def apply_children(node : XML::Node, rule_sets : Array(RuleSet))
    rule_set = RuleSet.new
    rule_sets.push(rule_set)

    node.children.each do |child|
      if child.type == XML::Type::ELEMENT_NODE
        if child.name == "styles"
          rule_set.add_rules(child.text)
        else
          apply(child, rule_sets)
        end
      end
    end

    rule_sets.pop
  end
end
