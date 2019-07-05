require "./spec_helper"

include Caramel::Widgets

class Bar < Widget
end

describe Caramel::Widgets do
  describe "#register" do
    it "should register a tag" do
      Factory.register("foo") { |parent, node| Widget.new }
      Factory.tags.should contain("foo")
    end
  end

  describe "#make" do
    Factory.register("bar") { |parent, node| Bar.new }
    container = Container.new
    node = XML.parse("<bar />")

    it "should make a Bar widget" do
      Factory.make("bar", container, node).should be_a(Bar)
    end

    it "should raise an exception for an unknown tag" do
      expect_raises(Factory::UnregisteredWidget) do
        Factory.make("foobar", container, node)
      end
    end
  end
end
