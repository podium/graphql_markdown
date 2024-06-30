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

  @login_response %{
    "description" => nil,
    "enumValues" => nil,
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "idToken",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
        }
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "refreshToken",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
        }
      }
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "LoginResponse",
    "possibleTypes" => nil
  }

  @unexpected_request %{
    "description" => "Unacceptable input from user",
    "enumValues" => nil,
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => "The type of violation",
        "isDeprecated" => false,
        "name" => "key",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
        }
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => "An explanation on how the user can proceed",
        "isDeprecated" => false,
        "name" => "message",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
        }
      }
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "UnexpectedRequest",
    "possibleTypes" => nil
  }

  @login_response_v2 %{
    "description" => "The response for password login",
    "enumValues" => nil,
    "fields" => nil,
    "inputFields" => nil,
    "interfaces" => nil,
    "kind" => "UNION",
    "name" => "LoginResponseV2",
    "possibleTypes" => [
      %{"kind" => "OBJECT", "name" => "LoginResponse", "ofType" => nil},
      %{"kind" => "OBJECT", "name" => "UnexpectedRequest", "ofType" => nil}
    ]
  }

  @password_login_v2_mutation %{
    "args" => [
      %{
        "defaultValue" => nil,
        "description" => nil,
        "name" => "input",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{
            "kind" => "INPUT_OBJECT",
            "name" => "PasswordLoginInput",
            "ofType" => nil
          }
        }
      }
    ],
    "deprecationReason" => nil,
    "description" => "Version 2 of password login",
    "isDeprecated" => false,
    "name" => "passwordLoginV2",
    "type" => %{"kind" => "UNION", "name" => "LoginResponseV2", "ofType" => nil}
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

  @character_interface %{
    "description" => "Information about a character",
    "enumValues" => nil,
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "id",
        "type" => %{"kind" => "SCALAR", "name" => "ID", "ofType" => nil}
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => "The name",
        "isDeprecated" => false,
        "name" => "name",
        "type" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
      }
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "INTERFACE",
    "name" => "Character",
    "possibleTypes" => [
      %{"kind" => "OBJECT", "name" => "Human", "ofType" => nil},
      %{"kind" => "OBJECT", "name" => "Droid", "ofType" => nil}
    ]
  }

  @human_object %{
    "description" => nil,
    "enumValues" => nil,
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "id",
        "type" => %{"kind" => "SCALAR", "name" => "ID", "ofType" => nil}
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "name",
        "type" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "age",
        "type" => %{"kind" => "SCALAR", "name" => "Int", "ofType" => nil}
      }
    ],
    "inputFields" => nil,
    "interfaces" => [
      %{"kind" => "INTERFACE", "name" => "Character", "ofType" => nil}
    ],
    "kind" => "OBJECT",
    "name" => "Human",
    "possibleTypes" => nil
  }

  @droid_object %{
    "description" => nil,
    "enumValues" => nil,
    "fields" => [
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "id",
        "type" => %{"kind" => "SCALAR", "name" => "ID", "ofType" => nil}
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "name",
        "type" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
      },
      %{
        "args" => [],
        "deprecationReason" => nil,
        "description" => nil,
        "isDeprecated" => false,
        "name" => "primaryFunction",
        "type" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
      }
    ],
    "inputFields" => nil,
    "interfaces" => [
      %{"kind" => "INTERFACE", "name" => "Character", "ofType" => nil}
    ],
    "kind" => "OBJECT",
    "name" => "Droid",
    "possibleTypes" => nil
  }

  @hero_for_episode_query %{
    "args" => [
      %{
        "defaultValue" => nil,
        "description" => nil,
        "name" => "episode",
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
    "name" => "heroForEpisode",
    "type" => %{"kind" => "INTERFACE", "name" => "Character", "ofType" => nil}
  }

  @droids_in_episode_query %{
    "args" => [
      %{
        "defaultValue" => nil,
        "description" => nil,
        "name" => "episode",
        "type" => %{
          "kind" => "NON_NULL",
          "name" => nil,
          "ofType" => %{"kind" => "SCALAR", "name" => "String", "ofType" => nil}
        }
      }
    ],
    "deprecationReason" => nil,
    "description" => "Get disputes",
    "isDeprecated" => false,
    "name" => "droidsInEpisode",
    "type" => %{
      "kind" => "LIST",
      "name" => nil,
      "ofType" => %{"kind" => "OBJECT", "name" => "Droid", "ofType" => nil}
    }
  }

  @root_query %{
    "fields" => [
      @user_sso_details_query,
      @hero_for_episode_query,
      @droids_in_episode_query
    ],
    "inputFields" => nil,
    "interfaces" => [],
    "kind" => "OBJECT",
    "name" => "RootQueryType",
    "possibleTypes" => nil
  }

  @root_mutation %{
    "fields" => [
      @generate_login_code_mutation,
      @password_login_v2_mutation
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
      @user_sso_details_object,
      @login_response,
      @unexpected_request,
      @human_object,
      @droid_object
    ],
    unions: [
      @login_response_v2
    ],
    interfaces: [
      @character_interface
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

    test "returns the return type for an operation that has a union in its return type" do
      expected_return_type = %{
        possible_types: [
          %{name: "LoginResponse", type: "OBJECT"},
          %{name: "UnexpectedRequest", type: "OBJECT"}
        ],
        kind: "UNION",
        name: "LoginResponseV2"
      }

      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "mutations",
          @password_login_v2_mutation,
          @schema_details
        )

      assert operation_details.return_type == expected_return_type
    end

    test "returns the return type for an operation that has an interface in its return type" do
      expected_return_type = %{
        fields: [
          %{name: "id", type: "SCALAR"},
          %{name: "name", type: "SCALAR"}
        ],
        possible_types: [
          %{name: "Human", type: "OBJECT"},
          %{name: "Droid", type: "OBJECT"}
        ],
        kind: "INTERFACE",
        name: "Character"
      }

      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "queries",
          @hero_for_episode_query,
          @schema_details
        )

      assert operation_details.return_type == expected_return_type
    end

    test "returns the return type for an operation that has a list as its return type" do
      expected_return_type = %{
        fields: [
          %{name: "id", type: "SCALAR"},
          %{name: "name", type: "SCALAR"},
          %{name: "primaryFunction", type: "SCALAR"}
        ],
        kind: "LIST",
        name: nil
      }

      operation_details =
        OperationDetailsHelpers.generate_operation_details(
          "queries",
          @droids_in_episode_query,
          @schema_details
        )

      assert operation_details.return_type == expected_return_type
    end
  end
end
