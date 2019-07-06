require "./spec_helper"

module Caramel::Widgets
  class Bar < Widget
  end

  describe Caramel::Widgets do
    describe "#register" do
      it "should register a tag" do
        Factory.register("foo") { |parent, node| Widget.new(parent, node) }
        Factory.tags.should contain("foo")
      end
    end

    describe "#make" do
      Factory.register("bar") { |parent, node| Bar.new(parent, node) }
      doc = Document.new
      node = XML.parse("<bar />")

      it "should make a Bar widget" do
        Factory.make("bar", doc, node).should be_a(Bar)
      end

      it "should raise an exception for an unknown tag" do
        expect_raises(Factory::UnregisteredWidget) do
          Factory.make("foobar", doc, node)
        end
      end
    end
  end
end
