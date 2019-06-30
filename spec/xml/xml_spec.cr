require "./spec_helper"

describe XML do
  doc = File.open(File.join(__DIR__, "xml_spec.xml")) { |f| XML.parse(f) }

  describe "#each" do
    it "should iterate nodes" do
      count = 0
      doc.each { count += 1 }
      count.should eq 11
    end

    it "should iterate elements" do
      expected = [] of String
      doc.each(type: XML::Type::ELEMENT_NODE) { |elem| expected << elem.name }
      expected.should eq %w(doc page title styles)
    end

    it "should iterate named elements" do
      expected = [] of String
      doc.each(type: XML::Type::ELEMENT_NODE, name: "styles") { |elem| expected << elem.name }
      expected.should eq %w(styles)
    end
  end
end
