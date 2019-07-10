require "./spec_helper"

module Caramel
  describe Caramel do
    context "selectors" do
      describe "#regex_string_for_selector" do
        it "should match tag" do
          regex_string_for_selector("foo").should eq <<-'RE'
        foo(#\w+)?(\.\w+)*$
        RE
        end

        it "should match tag with id" do
          regex_string_for_selector("foo#bar").should eq <<-'RE'
        foo#bar(\.\w+)*$
        RE
        end

        it "should match tag with class" do
          regex_string_for_selector("foo.bar").should eq <<-'RE'
        foo(#\w+)?(\.\w+)*\.bar(\.\w+)*$
        RE
        end

        it "should match id" do
          regex_string_for_selector("#bar").should eq <<-'RE'
        \w+#bar(\.\w+)*$
        RE
        end

        it "should match class" do
          regex_string_for_selector(".bar").should eq <<-'RE'
        \w+(#\w+)?(\.\w+)*\.bar(\.\w+)*$
        RE
        end

        it "should match tag with class child of tag with id" do
          regex_string_for_selector("foo#bar>foo.bar").should eq <<-'RE'
        foo#bar(\.\w+)*/foo(#\w+)?(\.\w+)*\.bar(\.\w+)*$
        RE
        end

        it "should match tag with class descendant of tag with id" do
          regex_string_for_selector("foo#bar foo.bar").should eq <<-'RE'
        foo#bar(\.\w+)*/([^/]+/)*foo(#\w+)?(\.\w+)*\.bar(\.\w+)*$
        RE
        end

        it "should match list of tags" do
          regex_string_for_selector("foo, bar").should eq <<-'RE'
        (foo(#\w+)?(\.\w+)*$|bar(#\w+)?(\.\w+)*$)
        RE
        end
      end

      describe "#regex_for_selector" do
        context "tags" do
          re = regex_for_selector("foo")

          it "should match tag" do
            re.should match("foo")
          end

          it "should match a tag with an id" do
            re.should match("foo#bar")
          end

          it "should match a tag with class" do
            re.should match("foo.bar")
          end

          it "should match a tag with an id and a class" do
            re.should match("foo#bar.baz")
          end
        end

        context "comma list matches" do
          re = regex_for_selector("foo, bar")

          it "should match the first tag" do
            re.should match("foo")
          end
          it "should match the first tag with an id" do
            re.should match("foo#bar")
          end
          it "should match the second tag" do
            re.should match("bar")
          end
          it "should match the second tag with a class" do
            re.should match("bar.baz")
          end
          it "should not match an unspecified tag" do
            re.should_not match("baz")
          end
        end

        context "id matches" do
          re = regex_for_selector("#bar")

          it "should not match just a simple tag" do
            re.should_not match("foo")
          end
          it "should match a tag with the specified id" do
            re.should match("foo#bar")
          end
          it "should not match a tag with a class but no id" do
            re.should_not match("foo.bar")
          end
          it "should match a tag with the specified id and a class" do
            re.should match("foo#bar.baz")
          end
        end

        context "class matches" do
          re = regex_for_selector(".bar")

          it "should not match just a simple tag" do
            re.should_not match("foo")
          end
          it "should not match a tag with an id but no class" do
            re.should_not match("foo#bar")
          end
          it "should match a tag with the specified class" do
            re.should match("foo.bar")
          end
          it "should not match a tag with an id named the same as the specified class" do
            re.should_not match("foo#bar.baz")
          end
        end

        context "another class matches" do
          re = regex_for_selector(".baz")

          it "should not match just a simple tag" do
            re.should_not match("foo")
          end

          it "should not match a tag with an id but no class" do
            re.should_not match("foo#bar")
          end

          it "should not match a tag with the wrong class" do
            re.should_not match("foo.bar")
          end

          it "should match a tag with an id and the specified class" do
            re.should match("foo#bar.baz")
          end
        end

        context "matching a direct child" do
          re = regex_for_selector("foo#bar>foo.bar")

          it "should match an element exactly as specified" do
            re.should match("foo#bar/foo.bar")
          end

          it "should not match an element where the id and the class have been switched" do
            re.should_not match("foo.bar/foo#bar")
          end

          it "should not match an element where an id has been traded for a class" do
            re.should_not match("foo#bar/foo#bar")
          end

          it "should not match an element where a class has been traded for an id" do
            re.should_not match("foo.bar/foo.bar")
          end

          it "should match an element as specified with a class added to the parent" do
            re.should match("foo#bar.baz/foo.bar")
          end

          it "should match an element as specified with a class added to the child" do
            re.should match("foo#bar/foo.bar.baz")
          end

          it "should match an element as specified with classes added to both parent and child" do
            re.should match("foo#bar.baz/foo.bar.baz")
          end
        end

        context "matching an indirect child" do
          re = regex_for_selector("foo#bar foo.bar")

          it "should also match a direct child" do
            re.should match("foo#bar/foo.bar")
          end

          it "should not match a direct child where the id and the class have been switched" do
            re.should_not match("foo.bar/foo#bar")
          end

          it "should not match a direct child where an id has been traded for a class" do
            re.should_not match("foo#bar/foo#bar")
          end

          it "should not match an element where a class has been traded for an id" do
            re.should_not match("foo.bar/foo.bar")
          end

          it "should match a direct child as specified with a class added to the parent" do
            re.should match("foo#bar.baz/foo.bar")
          end

          it "should match a direct child as specified with a class added to the child" do
            re.should match("foo#bar/foo.bar.baz")
          end

          it "should match a direct child as specified with classes added to both parent and child" do
            re.should match("foo#bar.baz/foo.bar.baz")
          end

          it "should match a descendant separated by a simple tag" do
            re.should match("foo#bar.baz/a/foo.bar.baz")
          end

          it "should match a descendant separated by a tag with an id" do
            re.should match("foo#bar.baz/a#b/foo.bar.baz")
          end

          it "should match a descendant separated by a tag with a class" do
            re.should match("foo#bar.baz/a.c/foo.bar.baz")
          end

          it "should match a descendant separated by a tag with an id and class" do
            re.should match("foo#bar.baz/a#b.c/foo.bar.baz")
          end

          it "should match a descendant separated by an id" do
            re.should match("foo#bar.baz/#b/foo.bar.baz")
          end

          it "should match a descendant separated by a class" do
            re.should match("foo#bar.baz/.c/foo.bar.baz")
          end
        end
      end
    end
  end
end
