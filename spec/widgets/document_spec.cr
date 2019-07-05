require "./spec_helper"

include Caramel::Widgets

describe Caramel::Widgets::Document do
  describe "#new" do
    it "should initialize itself and children from XML document" do
      doc = Document.new(File.join(__DIR__, "document_spec.crml"))
      doc.pages.size.should eq 2
      doc.pages[0].widgets.size.should eq 1
      doc.pages[1].widgets.size.should eq 1
      doc.pages[1].widgets[0].as(Container).widgets.size.should eq 1
      # doc.node.xpath_node("//p")["class"].should contain("basic-latin")
    end
  end
end
