defmodule GraphqlMarkdown.SchemaTest do
  use ExUnit.Case, async: true
  alias GraphqlMarkdown.Schema
  doctest GraphqlMarkdown

  @generate_login_code_response %{
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "processed",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{
            "kind" => "SCALAR",
            "name" => "Boolean",
            "ofType" => nil
          }
        }
      }
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "GenerateLoginCodeResponse",
    "possibleTypes" => nil
  }
  @generate_login_code %{
    "fields" => [
      %{
        "args" => [
          %{
            "defaultValue" => nil,
            "description" => nil,
            "name" => "emailOrPhone",
            "type" => %{
              "kind" => "NON_NULL",
              "name" => nil,
              "ofType" => %{
                "kind" => "SCALAR",
                "name" => "String",
                "ofType" => nil
              }
            }
          }
        ],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "generateLoginCode",
        "type" => %{
          "kind" => "OBJECT",
          "name" => "GenerateLoginCodeResponse",
          "ofType" => nil
        }
      }
    ]
  }

  @enum_value %{
    "fields" => [],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "__EnumValue",
    "possibleTypes" => nil
  }

  @root_query %{
    "fields" => [],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "RootQueryType",
    "possibleTypes" => nil
  }

  @root_mutation %{
    "fields" => [
      @generate_login_code
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "RootMutationType",
    "possibleTypes" => nil
  }

  @other_type %{
    "fields" => [],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "otherType",
    "possibleTypes" => nil
  }

  @schema_test %{
    "mutationType" => %{"name" => "RootMutationType"},
    "queryType" => %{"name" => "RootQueryType"},
    "types" => [
      @generate_login_code_response,
      @enum_value,
      @root_query,
      @root_mutation,
      @other_type
    ]
  }

  describe "#mutation_type" do
    test "get the mutation type " do
      assert Schema.mutation_type(@schema_test) == "RootMutationType"
    end
  end

  describe "#query_type" do
    test "get the query type " do
      assert Schema.query_type(@schema_test) == "RootQueryType"
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
               @generate_login_code_response,
               @root_query,
               @root_mutation,
               @other_type
             ]
    end
  end

  describe "#find_and_sort_type" do
    test "find mutation types" do
      assert Schema.find_and_sort_type(Schema.types(@schema_test), "name", "RootMutationType") ==
               [@root_mutation]
    end

    test "find query types" do
      assert Schema.find_and_sort_type(Schema.types(@schema_test), "name", "RootQueryType") == [
               @root_query
             ]
    end

    test "find Object types" do
      assert Schema.find_and_sort_type(Schema.types(@schema_test), "kind", "OBJECT") == [
               @generate_login_code_response,
               @root_mutation,
               @root_query,
               @other_type
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
