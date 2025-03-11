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

  describe "#graphql_operation_code_block" do
    test "creates a GQL text block for the operation" do
      operation_details = %{
        arguments: [%{name: "emailOrPhone", required: true, type: "String"}],
        operation_name: "generateLoginCode",
        operation_type: "mutation",
        return_type: %{
          kind: "OBJECT",
          name: "GenerateLoginCodeResponse",
          fields: [
            %{name: "processed", type: "SCALAR"}
          ]
        }
      }

      expected_text =
        """
        ```gql
        mutation GenerateLoginCode($emailOrPhone: String!) {
          generateLoginCode(emailOrPhone: $emailOrPhone) {
            processed
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
    end

    test "returns comma-separated arguments and types when there is more than one argument" do
      operation_details = %{
        arguments: [
          %{name: "username", required: true, type: "String"},
          %{name: "password", required: true, type: "String"}
        ],
        operation_name: "login",
        operation_type: "mutation",
        return_type: %{
          kind: "OBJECT",
          name: "LoginResponse",
          fields: [
            %{name: "idToken", type: "SCALAR"},
            %{name: "refreshToken", type: "SCALAR"}
          ]
        }
      }

      expected_text =
        """
        ```gql
        mutation Login($username: String!, $password: String!) {
          login(username: $username, password: $password) {
            idToken
            refreshToken
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
    end

    test "returns an empty object for an object return type" do
      operation_details = %{
        arguments: [
          %{name: "refreshToken", required: true, type: "String"}
        ],
        operation_name: "refreshIdToken",
        operation_type: "mutation",
        return_type: %{
          kind: "OBJECT",
          name: "RefreshIdTokenResponse",
          fields: [
            %{name: "idToken", type: "SCALAR"},
            %{name: "userSsoDetails", type: "OBJECT"}
          ]
        }
      }

      expected_text =
        """
        ```gql
        mutation RefreshIdToken($refreshToken: String!) {
          refreshIdToken(refreshToken: $refreshToken) {
            idToken
            userSsoDetails {
            }
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
    end

    test "does not include argument parentheses when there are no arguments" do
      operation_details = %{
        arguments: [],
        operation_name: "currentTime",
        operation_type: "query",
        return_type: %{
          kind: "SCALAR",
          name: "String"
        }
      }

      expected_text =
        """
        ```gql
        query CurrentTime {
          currentTime {
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
    end

    test "does not include return fields when the return type is scalar" do
      operation_details = %{
        arguments: [],
        operation_name: "currentTime",
        operation_type: "query",
        return_type: %{
          kind: "SCALAR",
          name: "String"
        }
      }

      expected_text =
        """
        ```gql
        query CurrentTime {
          currentTime {
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
    end

    test "handles NON_NULL return type by unwrapping to the inner type" do
      operation_details = %{
        arguments: [],
        operation_name: "requiredField",
        operation_type: "query",
        return_type: %{
          kind: "NON_NULL",
          name: nil,
          ofType: %{
            kind: "OBJECT",
            name: "RequiredResponse",
            fields: [
              %{name: "isRequired", type: "SCALAR"},
              %{name: "metadata", type: "SCALAR"}
            ]
          }
        }
      }

      expected_text =
        """
        ```gql
        query RequiredField {
          requiredField {
            isRequired
            metadata
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
    end

    test "handles NON_NULL return type without ofType field" do
      operation_details = %{
        arguments: [],
        operation_name: "emptyRequired",
        operation_type: "query",
        return_type: %{
          kind: "NON_NULL",
          name: "String"
        }
      }

      expected_text =
        """
        ```gql
        query EmptyRequired {
          emptyRequired {
          }
        }
        ```
        """

      assert MarkdownHelpers.graphql_operation_code_block(operation_details) == expected_text
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
