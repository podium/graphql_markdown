defmodule GraphqlMarkdown.SchemaTest do
  use ExUnit.Case, async: true
  alias GraphqlMarkdown.Schema
  doctest GraphqlMarkdown

  @schema_test %{
    "mutationType" => %{"name" => "RootMutationType"},
    "queryType" => %{"name" => "someQueryName"},
    "types" => [
      %{
        "fields" => [],
        "inputFields" => nil,
        "interfaces" => [],
        "kind" => "OBJECT",
        "name" => "__EnumValue",
        "possibleTypes" => nil
      },
      %{
        "fields" => [],
        "inputFields" => nil,
        "interfaces" => [],
        "kind" => "OBJECT",
        "name" => "someQueryName",
        "possibleTypes" => nil
      },
      %{
        "fields" => [],
        "inputFields" => nil,
        "interfaces" => [],
        "kind" => "OBJECT",
        "name" => "RootMutationType",
        "possibleTypes" => nil
      },
      %{
        "fields" => [],
        "inputFields" => nil,
        "interfaces" => [],
        "kind" => "OBJECT",
        "name" => "otherType",
        "possibleTypes" => nil
      }
    ]
  }

  describe "#mutation_type" do
    test "get the mutation type " do
      assert Schema.mutation_type(@schema_test) == "RootMutationType"
    end
  end

  describe "#query_type" do
    test "get the query type " do
      assert Schema.query_type(@schema_test) == "someQueryName"
    end
  end

  describe "#schema_from_json" do
    test "get the schema type " do
      assert Schema.schema_from_json(%{"data" => %{"__schema" => "some schema"}}) ==
               {:ok, "some schema"}
    end

    test "return an error on invalid document detected" do
      assert Schema.schema_from_json(%{"data" => %{"toto" => "some schema"}}) ==
               {:error, :invalid_schema}
    end
  end

  describe "#types" do
    test "find all types and filter __ types" do
      assert Schema.types(@schema_test) == [
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "someQueryName",
                 "possibleTypes" => nil
               },
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "RootMutationType",
                 "possibleTypes" => nil
               },
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "otherType",
                 "possibleTypes" => nil
               }
             ]
    end
  end

  describe "#find_and_sort_type" do
    test "find mutation types" do
      assert Schema.find_and_sort_type(Schema.types(@schema_test), "name", "RootMutationType") ==
               [
                 %{
                   "fields" => [],
                   "inputFields" => nil,
                   "interfaces" => [],
                   "kind" => "OBJECT",
                   "name" => "RootMutationType",
                   "possibleTypes" => nil
                 }
               ]
    end

    test "find query types" do
      assert Schema.find_and_sort_type(Schema.types(@schema_test), "name", "someQueryName") == [
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "someQueryName",
                 "possibleTypes" => nil
               }
             ]
    end

    test "find Object types" do
      assert Schema.find_and_sort_type(Schema.types(@schema_test), "kind", "OBJECT") == [
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "RootMutationType",
                 "possibleTypes" => nil
               },
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "otherType",
                 "possibleTypes" => nil
               },
               %{
                 "fields" => [],
                 "inputFields" => nil,
                 "interfaces" => [],
                 "kind" => "OBJECT",
                 "name" => "someQueryName",
                 "possibleTypes" => nil
               }
             ]
    end
  end

  describe "#full_field_type" do
    test "simple scalar" do
      assert Schema.full_field_type(%{
               "kind" => "SCALAR",
               "name" => "String",
               "ofType" => nil
             }) == "String"
    end

    test "list of scalar" do
      assert Schema.full_field_type(%{
               "kind" => "LIST",
               "name" => nil,
               "ofType" => %{
                 "kind" => "SCALAR",
                 "name" => "String",
                 "ofType" => nil
               }
             }) == "\\[String\\]"
    end

    test "non-null simple scalar" do
      assert Schema.full_field_type(%{
               "kind" => "NON_NULL",
               "name" => nil,
               "ofType" => %{
                 "kind" => "SCALAR",
                 "name" => "String",
                 "ofType" => nil
               }
             }) == "String!"
    end

    test "list of non-null scalar" do
      assert Schema.full_field_type(%{
               "kind" => "LIST",
               "name" => nil,
               "ofType" => %{
                 "kind" => "NON_NULL",
                 "name" => nil,
                 "ofType" => %{
                   "kind" => "SCALAR",
                   "name" => "String",
                   "ofType" => nil
                 }
               }
             }) == "\\[String!\\]"
    end

    test "non-null list of non-null scalar" do
      assert Schema.full_field_type(%{
               "kind" => "NON_NULL",
               "name" => nil,
               "ofType" => %{
                 "kind" => "LIST",
                 "name" => nil,
                 "ofType" => %{
                   "kind" => "NON_NULL",
                   "name" => nil,
                   "ofType" => %{
                     "kind" => "SCALAR",
                     "name" => "String",
                     "ofType" => nil
                   }
                 }
               }
             }) == "\\[String!\\]!"
    end
  end

  describe "#field_type" do
    test "simple scalar" do
      assert Schema.field_type(%{
               "kind" => "SCALAR",
               "name" => "String",
               "ofType" => nil
             }) == "String"
    end

    test "list of scalar" do
      assert Schema.field_type(%{
               "kind" => "LIST",
               "name" => nil,
               "ofType" => %{
                 "kind" => "SCALAR",
                 "name" => "String",
                 "ofType" => nil
               }
             }) == "String"
    end

    test "non-null simple scalar" do
      assert Schema.field_type(%{
               "kind" => "NON_NULL",
               "name" => nil,
               "ofType" => %{
                 "kind" => "SCALAR",
                 "name" => "String",
                 "ofType" => nil
               }
             }) == "String"
    end

    test "list of non-null scalar" do
      assert Schema.field_type(%{
               "kind" => "LIST",
               "name" => nil,
               "ofType" => %{
                 "kind" => "NON_NULL",
                 "name" => nil,
                 "ofType" => %{
                   "kind" => "SCALAR",
                   "name" => "String",
                   "ofType" => nil
                 }
               }
             }) == "String"
    end

    test "non-null list of non-null scalar" do
      assert Schema.field_type(%{
               "kind" => "NON_NULL",
               "name" => nil,
               "ofType" => %{
                 "kind" => "LIST",
                 "name" => nil,
                 "ofType" => %{
                   "kind" => "NON_NULL",
                   "name" => nil,
                   "ofType" => %{
                     "kind" => "SCALAR",
                     "name" => "String",
                     "ofType" => nil
                   }
                 }
               }
             }) == "String"
    end
  end
end
