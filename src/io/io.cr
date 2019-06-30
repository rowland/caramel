require "xml"
require "./../xml"
require "http/client"

module Caramel::IO
  extend self

  RE_HTTP_URI = /^https?:\/\//i
  RE_FILE_URI = /^file:\/\/\//i

  def expand_element(element : XML::Node, base_uri : String, attr : String)
    if uri = element[attr]?
      full_uri = File.join(base_uri, uri)
      element.content = case
                        when uri =~ RE_HTTP_URI
                          HTTP::Client.get(uri).body
                        when uri =~ RE_FILE_URI
                          File.read(uri.sub(RE_FILE_URI, ""))
                        when full_uri =~ RE_HTTP_URI
                          HTTP::Client.get(full_uri).body
                        when full_uri =~ RE_FILE_URI
                          File.read(full_uri.sub(RE_FILE_URI, ""))
                        else
                          File.read(File.join(base_uri, uri))
                        end
    end
  end

  def expand(node : XML::Node, base_uri : String, name : String, attr : String)
    node.each(type: XML::Type::ELEMENT_NODE, name: name) { |node| expand_element(node, base_uri, attr) }
  end
end
