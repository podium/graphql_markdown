defmodule GraphqlMarkdown.OperationDetailsHelpersTest do
  use ExUnit.Case, async: true

  alias GraphqlMarkdown.OperationDetailsHelpers

  @generate_login_code_response_object %{
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
  @generate_login_code_mutation %{
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

  @user_sso_details_object %{
    "description" => nil,
    "enumValues" => nil,
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "domain",
        "type" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "ssoEnabled",
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
    "name" => "UserSsoDetails",
    "possibleTypes" => nil
  }

  @user_sso_details_query %{
    "args" => [
      %{
        "defaultValue" => nil,
        "description" => nil,
        "name" => "emailOrPhone",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
        }
      },
      %{
        "defaultValue" => nil,
        "description" => nil,
        "name" => "includeArchived",
        "type" => %{
          "kind" => "SCALAR",
          "name" => "Boolean",
          "ofType" => nil
        }
      }
    ],
    "deprecationReason" => nil,
    "description" => nil,
    "isDeprecated" => false,
    "name" => "userSsoDetails",
    "type" => %{"kind" => "OBJECT", "name" => "UserSsoDetails", "ofType" => nil}
  }

  @root_query %{
    "fields" => [
      @user_sso_details_query
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "RootQueryType",
    "possibleTypes" => nil
  }

  @root_mutation %{
    "fields" => [
      @generate_login_code_mutation
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "RootMutationType",
    "possibleTypes" => nil
  }

  @schema_details %GraphqlMarkdown.Schema{
    mutations: @root_mutation,
    queries: @root_query,
    inputs: [],
    objects: [
      @generate_login_code_response_object,
      @user_sso_details_object
    ]
  }

  describe "generate_operation_details/3" do
    test "returns 'query' as the operation type for queries" do
      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "queries",
          @user_sso_details_query,
          @schema_details
        )

      assert operation_details.operation_type == "query"
    end

    test "returns 'mutation' as the operation type for mutations" do
      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "mutations",
          @generate_login_code_mutation,
          @schema_details
        )

      assert operation_details.operation_type == "mutation"
    end

    test "returns the operation name" do
      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "queries",
          @user_sso_details_query,
          @schema_details
        )

      assert operation_details.operation_name == "userSsoDetails"
    end

    test "returns the arguments for an operation" do
      expected_arguments = [
        %{name: "emailOrPhone", required: true, type: "String"},
        %{name: "includeArchived", required: false, type: "Boolean"}
      ]

      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "queries",
          @user_sso_details_query,
          @schema_details
        )

      assert operation_details.arguments == expected_arguments
    end

    test "returns the return type for an operation" do
      expected_return_type = %{
        fields: [
          %{name: "domain", type: "SCALAR"},
          %{name: "ssoEnabled", type: "SCALAR"}
        ],
        kind: "OBJECT",
        name: "UserSsoDetails"
      }

      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "queries",
          @user_sso_details_query,
          @schema_details
        )

      assert operation_details.return_type == expected_return_type
    end
  end
end
