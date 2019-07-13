require "./spec_helper"
require "../src/measurement"

module Caramel::Measurement
  context "measurement parsing and conversion" do
    describe "#parse_measurement" do
      it "should parse a simple number" do
        parse("5").should eq 5
      end

      it "should parse a fractional number" do
        parse("5.7").should eq 5.7
      end

      it "should parse a negative number" do
        parse("-5").should eq -5
      end

      it "should parse a negative fractional number" do
        parse("-5.7").should eq -5.7
      end

      it "should parse a simple number and units" do
        parse("2in").should eq 144
      end

      it "should parse a fractional number and units" do
        parse("1.5in").should eq 108
      end

      it "should parse a negative fractional number and units" do
        parse("-1.5in").should eq -108
      end

      it "should allow surrounding whitespace" do
        parse(" -1.5in ").should eq -108
      end

      it "should return zero for unmatched patterns" do
        parse(" -1.5 in ").should eq 0
      end
    end

    describe "#from_units" do
      it "should handle points" do
        from_units(72, "pt").should eq 72
      end

      it "should handle inches" do
        from_units(1, "in").should eq 72
      end

      it "should handle centimeters" do
        from_units(1, "cm").should eq 28.35
      end

      it "should handle Dave points" do
        from_units(1000, "dp").should eq 72
      end

      it "should default to points" do
        from_units(72, "").should eq 72
      end
    end
  end
end
