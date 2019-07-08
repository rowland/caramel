require "xml"
require "./container"
require "./factory"

module Caramel::Widgets
  class Styles
    def initialize(parent : Container, node : XML::Node)
      text = String.build do |s|
        node.children.each do |n|
          if n.text? || n.comment?
            s << n.text
          end
        end
      end
      parent.rule_set.add_rules(text)
    end
  end

  register("styles") { |parent, node| Styles.new(parent, node) }
end
