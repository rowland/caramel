require "xml"
require "./rule"
require "./rule_set"
require "./selectors"

module Caramel::Styles
  extend self

  def apply(node : XML::Node,
            rule_sets = [] of RuleSet,
            custom_tags = {} of String => Hash(String, String))
    # apply node
    overrides = node.attributes.to_h
    if base_attrs = custom_tags[node.name]?
      custom_tag = base_attrs.delete("tag")
      node.attributes.merge!(base_attrs)
    end
    rule_sets.each do |rule_set|
      rule_set.each do |rule|
        node.attributes.merge!(rule.attrs) if rule.match?(node.path)
      end
    end
    node.attributes.merge!(overrides)

    # apply children
    rule_set = RuleSet.new
    rule_sets.push(rule_set)
    custom_tags = custom_tags.dup

    node.children.each do |child|
      if child.element?
        if child.name == "define"
          base_attrs = child.attributes.to_h
          if id = base_attrs.delete("id")
            custom_tags[id] = base_attrs
          end
          child.unlink
        elsif child.name == "styles"
          text = String.build do |s|
            child.children.each do |n|
              if n.text? || n.comment?
                s << n.text
              end
            end
          end
          rule_set.add_rules(text)
          child.unlink
        else
          apply(child, rule_sets, custom_tags)
        end
      end
    end

    rule_sets.pop

    # apply custom tag
    if custom_tag
      node.name = custom_tag
    end
  end
end
