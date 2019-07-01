require "xml"
require "./rule"
require "./rule_set"
require "./selectors"

module Caramel::Styles
  extend self

  def apply(node : XML::Node, rule_sets = [] of RuleSet)
    apply_node(node, rule_sets)
    apply_children(node, rule_sets)
  end

  private def apply_node(node : XML::Node, rule_sets : Array(RuleSet))
    overrides = node.attributes.to_h
    rule_sets.each do |rule_set|
      rule_set.each do |rule|
        rule.attrs.each do |key, value|
          if rule.selector_re =~ node.path
            node.attributes[key] = value
          end
        end
      end
    end
    node.attributes.merge!(overrides)
  end

  private def apply_children(node : XML::Node, rule_sets : Array(RuleSet))
    rule_set = RuleSet.new
    rule_sets.push(rule_set)

    node.children.each do |child|
      if child.type == XML::Type::ELEMENT_NODE
        if child.name == "styles"
          rule_set.add_rules(child.text)
          child.unlink
        else
          apply(child, rule_sets)
        end
      end
    end

    rule_sets.pop
  end
end
