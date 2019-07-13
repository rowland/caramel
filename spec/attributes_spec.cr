require "../src/attributes"

module Caramel
  describe Attributes do
    describe "#measurement" do
      attrs = Attributes{
        "m36"    => "36",
        "m36pt"  => "36pt",
        "m2"     => "2",
        "m2in"   => "2in",
        "m1"     => "1",
        "m1cm"   => "1cm",
        "m250"   => "250",
        "m250dp" => "250dp",
        "bogus"  => "",
      }

      it "should parse default points" do
        attrs.measurement("m36", "pt").should eq 36
      end

      it "should parse points" do
        attrs.measurement("m36pt").should eq 36
      end

      it "should parse default inches" do
        attrs.measurement("m2", "in").should eq 144
      end

      it "should parse inches" do
        attrs.measurement("m2in").should eq 144
      end

      it "should parse default centimeters" do
        attrs.measurement("m1", "cm").should eq 28.35
      end

      it "should parse centimeters" do
        attrs.measurement("m1cm").should eq 28.35
      end

      it "should parse default Dave points" do
        attrs.measurement("m250", "dp").should eq 18
      end

      it "should parse Dave points" do
        attrs.measurement("m250dp").should eq 18
      end
    end
  end
end
