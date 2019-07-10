require "string_scanner"
require "./rule"
require "./selectors"

module Caramel
  class RuleSet < Array(Rule)
    def add_rules(text : String)
      rule_scanner = StringScanner.new(text)
      while rule_scanner.scan(Rule::RE_RULE)
        selector_text, attrs_text = rule_scanner[1], rule_scanner[2]
        attrs = Hash(String, String).new
        attr_scanner = StringScanner.new(attrs_text)
        while attr_scanner.scan(Rule::RE_ATTRS)
          attrs[attr_scanner[1]] = attr_scanner[2]
        end
        self << Rule.new(selector_text, Caramel.regex_for_selector(selector_text), attrs)
      end
    end
  end
end
