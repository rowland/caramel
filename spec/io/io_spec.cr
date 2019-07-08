require "./spec_helper"
require "webmock"

describe Caramel::IO do
  io_spec_css = File.read(File.join(__DIR__, "io_spec.css"))
  doc = File.open(File.join(__DIR__, "io_spec.xml")) { |f| XML.parse(f) }

  http_io_spec_css = "doc page h1 { padding: 15 };"
  WebMock.stub(:get, "http://www.example.com/io_spec.css").to_return(body: http_io_spec_css)

  describe "#expand" do
    it "should expand external styles" do
      Caramel::IO.expand(doc, __DIR__, "styles", "src")
      nodes = doc.xpath_nodes("//styles")
      nodes[0].content.should eq(io_spec_css)
      nodes[1].content.should eq(http_io_spec_css)
    end
  end
end
