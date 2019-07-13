require "./spec_helper"
require "../src/page_style"

module Caramel
  describe PageStyle do
    context "A4 portrait" do
      ps = PageStyle.new("A4", "portrait")
      it "should have A4 portrait width and height" do
        ps.height.should eq 842
        ps.width.should eq 595
      end
    end

    context "A4 landscape" do
      ps = PageStyle.new("A4", "landscape")
      it "should have A4 landscape width and height" do
        ps.height.should eq 595
        ps.width.should eq 842
      end
    end

    context "with overridden width and height" do
      ps = PageStyle.new
      ps.height = 377
      ps.width = 233

      it "should have the custom height" do
        ps.height.should eq 377
      end

      it "should have the custom width" do
        ps.width.should eq 233
      end
    end

    describe "#dup" do
      it "changes to copy should leave original unchanged" do
        ps = PageStyle.new("A4", "portrait")
        ps.size.should eq "A4"
        ps.orientation.should eq "portrait"

        ps2 = ps.dup
        ps2.size = "B5"
        ps2.orientation = "landscape"

        ps.size.should eq "A4"
        ps.orientation.should eq "portrait"
      end
    end
  end
end
