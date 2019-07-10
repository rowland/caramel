module Caramel
  extend self

  def regex_for_selector(selector : String) : Regex
    Regex.new(regex_string_for_selector(selector))
  end

  RE_EXTRA_SPACES                = /\s{2,}/
  RE_SPACES_AROUND_ANGLE_BRACKET = /\s*>\s*/
  RES_GT                         = "/"
  RES_SPACE                      = RES_GT + %q|([^/]+/)*|
  RES_TAG                        = %q|\w+|
  RES_ID                         = %q|(#\w+)?|
  RES_MISC_CLASS                 = %q|(\.\w+)*|
  RES_SPEC_CLASS                 = %q|(\.\w+)*\.%s(\.\w+)*|

  private def regex_string_for_selector(selector : String) : String
    selector = selector.strip
    selector = selector.gsub(RE_EXTRA_SPACES, " ")
    selector = selector.gsub(RE_SPACES_AROUND_ANGLE_BRACKET, ">")

    selectors = selector.split(",").map(&.strip)
    result = selectors.map do |sel|
      groups = sel.split(" ")
      re_groups = groups.map { |group| regex_string_for_selector_group(group) }
      re_groups.join(RES_SPACE) + "$"
    end
    if result.size > 1
      return "(#{result.join("|")})"
    end
    if result.size == 1
      return result.first
    end
    ""
  end

  private def regex_string_for_selector_group(group : String) : String
    items = group.split(">")
    re_items = items.map { |item| regex_string_for_selector_item(item) }
    re_items.join(RES_GT)
  end

  private def regex_string_for_selector_item(item : String) : String
    t, k = item.split(".", 2) << ""
    if t == ""
      t = RES_TAG + RES_ID
    elsif t[0] == '#'
      t = RES_TAG + t
    elsif !t.includes?("#")
      t += RES_ID
    end
    if k == ""
      k = RES_MISC_CLASS
    else
      k = RES_SPEC_CLASS % k
    end
    t + k
  end
end
