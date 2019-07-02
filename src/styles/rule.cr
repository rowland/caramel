module Caramel::Styles
  class Rule
    RE_RULE  = /\s*([^\{]+?)\s*\{([^\}]+)\}/
    RE_ATTRS = /\s*([^:]+)\s*:\s*([^;]+)\s*;?/

    getter selector : String
    getter selector_re : Regex
    getter attrs : Hash(String, String)

    def initialize(@selector, @selector_re, @attrs)
    end

    def match?(path : String) : Bool
      !!(self.selector_re =~ path)
    end
  end
end
