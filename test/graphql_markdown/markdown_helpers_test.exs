defmodule GraphqlMarkdown.MarkdownHelpersTest do
  use ExUnit.Case, async: false
  alias GraphqlMarkdown.MarkdownHelpers
  doctest GraphqlMarkdown

  describe "#header" do
    test "it capitalize the header" do
      assert MarkdownHelpers.header("some Header that NeEd capitalizing", 1, true) ==
               "# Some header that need capitalizing"
    end

    test "it support different levels the header" do
      assert MarkdownHelpers.header("some Header that NeEd capitalizing", 3, false) ==
               "### some Header that NeEd capitalizing"
    end

    test "it default to not capitalizing a heading" do
      assert MarkdownHelpers.header("some Header that NeEd capitalizing", 1) ==
               "# some Header that NeEd capitalizing"
    end
  end

  describe "#list" do
    test "it capitalize the list" do
      assert MarkdownHelpers.list("some Header that NeEd capitalizing", 1, true) ==
               "  * Some header that need capitalizing"
    end

    test "it support different levels the list" do
      assert MarkdownHelpers.list("some Header that NeEd capitalizing", 2, false) ==
               "    * some Header that NeEd capitalizing"
    end

    test "it default to not capitalizing a list" do
      assert MarkdownHelpers.list("some Header that NeEd capitalizing", 1) ==
               "  * some Header that NeEd capitalizing"
    end
  end

  describe "#anchor" do
    test "it creates an anchor (link)" do
      assert MarkdownHelpers.anchor("Some Class") ==
               "[Some Class](#some class)"
    end

    test "it creates an anchor with different link than text" do
      assert MarkdownHelpers.anchor("Some Class", "Some Link") ==
               "[Some Class](#some link)"
    end
  end

  describe "#link" do
    test "it create a link for the text and url specified" do
      assert MarkdownHelpers.link("some text", "http://localhost") ==
               "[some text](http://localhost)"
    end

    test "it creates an anchor link if no url specified" do
      assert MarkdownHelpers.link("Some Class") ==
               "[Some Class](#some class)"
    end
  end

  describe "#table" do
    test "Generate a table with field and no data" do
      assert MarkdownHelpers.table([name: %{}, Description: %{}], []) ==
               "| name | Description |\n| ---- | ----------- |\n"
    end

    test "Generate a table with field and data" do
      assert MarkdownHelpers.table([name: %{}, Description: %{}], [
               ["toto", "some description"],
               ["titi", "another description"]
             ]) ==
               "| name | Description |\n| ---- | ----------- |\n| toto | some description |\n| titi | another description |"
    end
  end

  describe "#default_value" do
    test "return nothing when no default value is found as code" do
      assert MarkdownHelpers.default_value(nil) == ""
    end

    test "return the default value as code" do
      assert MarkdownHelpers.default_value("some text") == "The default value is `some text`"
    end
  end

  describe "#code" do
    test "display as code" do
      assert MarkdownHelpers.code("some text") == "`some text`"
    end
  end
end
