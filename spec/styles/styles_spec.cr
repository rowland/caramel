require "./spec_helper"

describe Caramel::Styles do
  describe "#apply" do
    doc = File.open(File.join(__DIR__, "styles_spec.xml")) { |f| XML.parse(f) }
    Caramel::IO.expand(doc, __DIR__, "styles", "src")

    it "should apply styles" do
      Caramel::Styles.apply(doc)
      # puts doc
    end
  end
end
