require "xml"
require "./rule"
require "./rule_set"
require "./selectors"

module Caramel::Styles
  extend self

  def apply(node : XML::Node,
            rule_sets = [] of RuleSet,
            custom_tags = {} of String => Hash(String, String))
    apply_node(node, rule_sets, custom_tags)
    apply_children(node, rule_sets, custom_tags)
    apply_custom_tag(node, custom_tags)
  end

  private def apply_node(node : XML::Node,
                         rule_sets : Array(RuleSet),
                         custom_tags : Hash(String, Hash(String, String)))
    overrides = node.attributes.to_h
    if base_attrs = custom_tags[node.name]?
      node.attributes.merge!(base_attrs)
    end
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

  private def apply_children(node : XML::Node,
                             rule_sets : Array(RuleSet),
                             custom_tags : Hash(String, Hash(String, String)))
    rule_set = RuleSet.new
    rule_sets.push(rule_set)
    custom_tags = custom_tags.dup

    node.children.each do |child|
      if child.type == XML::Type::ELEMENT_NODE
        if child.name == "define"
          base_attrs = child.attributes.to_h
          if id = base_attrs.delete("id")
            custom_tags[id] = base_attrs
          end
          child.unlink
        elsif child.name == "styles"
          text = String.build do |s|
            child.children.each do |n|
              if n.type == XML::Type::TEXT_NODE || n.type == XML::Type::COMMENT_NODE
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
  end
end

private def apply_custom_tag(node : XML::Node, custom_tags : Hash(String, Hash(String, String)))
  if node["tag"]?
    node.name = node.delete("tag")
  end
end
