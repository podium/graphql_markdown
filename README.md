# GraphqlMarkdown

Converts a JSON Graphql Schema to Markdown

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `graphql_markdown` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:graphql_markdown, "~> 0.1.2"}
  ]
end
```

And run:

    $ mix deps.get

    # will create a single file called graphql_schema.md in the current dir
    $ mix graphql_gen_markdown -f ./schema.json


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/graphql_markdown](https://hexdocs.pm/graphql_markdown).

## Quick Start

You can generate either single page with all the types or a multipage that will then generate separately Mutations, Queries, Enums etc, each in a different file.

### Single page

When you run the following

```shell
mix graphql_gen_markdown -f ./schema.json
```
it will generate the following file in your current folder:

./graphql_schema.md

You can change the default title for the single page with `-t` option.

### Multi pages

When you run the following

```shell
mix graphql_gen_markdown -f ./schema.json -m
```

it will generate the following files in your current folder:

  ./queries.md
  ./mutations.md
  ./objects.md
  ./inputs.md
  ./enums.md
  ./scalars.md
  ./interfaces.md
  ./unions.md

## Ingrate with ExDoc and Absinthe

You can easily automate the process with ExDoc by adding the following to your `mix.exs` file:

```elixir
defmodule Azeroth.MixProject do
  use Mix.Project

  # this is needed because the file are generated but if you run mix docs, Mix will check the existence of files first. so have to work around that
  @graphql_files [
    "guides/graphql/enums.md",
    "guides/graphql/inputs.md",
    "guides/graphql/interfaces.md",
    "guides/graphql/mutations.md",
    "guides/graphql/objects.md",
    "guides/graphql/queries.md",
    "guides/graphql/scalars.md",
    "guides/graphql/unions.md"
  ]
  ...

  defp aliases do
  [
    docs: [
      "absinthe.schema.json",
      "graphql_gen_markdown -f schema.json -o guides/graphql -m",
      "docs"
    ],...
  ]
```

Make sure the absinthe schema is specified or generated with that name. Or add to your config.exs:

```
config :absinthe, schema: YouApp.GraphQL.Schema
```

## Documentation

Documentation is [available on Hexdocs](https://hexdocs.pm/grapqhl_markdown/)

## Contributing

1. [Fork it!](http://github.com/rrrene/credo/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Emmanuel Pinault (@epinault)

## License

GraphqlMarkdown is released under the MIT License. See the LICENSE file for further details.