require "./spec_helper"

module Caramel
  describe Document do
    describe "#new" do
      doc = Document.new(File.join(__DIR__, "document_spec.crml"))

      it "should initialize itself and children from XML document" do
        doc.pages.size.should eq 2
        doc.pages[0].widgets.size.should eq 1
        doc.pages[1].widgets.size.should eq 1
        doc.pages[1].widgets[0].as(Container).widgets.size.should eq 1
      end

      it "should apply styles based on dynamic classes" do
        doc.pages[0].widgets[0].node["font"].should eq "Courier"
      end
    end

    describe "#draw" do
      doc = Document.new(File.join(__DIR__, "document_spec.crml"))

      it "should return a PDF" do
        doc.draw.should match /%PDF-1.7/
      end

      it "should default to letter" do
        doc.draw.should contain "MediaBox[0 0 612 792]"
      end

      context "page sizes" do
        data = Document.new(File.join(__DIR__, "document_spec_page_sizes.crml")).draw
        # puts data
        matches = data.scan(/MediaBox\[0 0 (\d+) (\d+)\]/)

        it "should have appropriate number of media boxes" do
          matches.size.should eq 5
          # puts matches.map(&.[0])
        end

        it "should have A4 media box for page 1" do
          matches[0][1].should eq "595"
          matches[0][2].should eq "842"
        end

        it "should have A4 landscape media box for page 2" do
          matches[1][1].should eq "842"
          matches[1][2].should eq "595"
        end

        it "should have B5 media box for page 3" do
          matches[2][1].should eq "499"
          matches[2][2].should eq "708"
        end

        it "should have B5 landscape media box for page 4" do
          matches[3][1].should eq "708"
          matches[3][2].should eq "499"
        end

        it "should have odd media box for page 5" do
          matches[4][1].should eq "277"
          matches[4][2].should eq "379"
        end
      end
    end
  end
end
