# GraphqlMarkdown

[![Build Status](https://github.com/podium/graphql_markdown/workflows/ci.yml/badge.svg)](https://github.com/podium/graphql_markdown/actions/workflows/ci.yml) [![Hex.pm](https://img.shields.io/hexpm/v/graphql_markdown.svg)](https://hex.pm/packages/graphql_markdown) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/graphql_markdown)

Converts a JSON Graphql Schema to Markdown

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `graphql_markdown` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:graphql_markdown, "~> 0.1.4"}
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

- ./graphql_schema.md

You can change the default title for the single page with `-t` option.

### Multi pages

When you run the following

```shell
mix graphql_gen_markdown -f ./schema.json -m
```

it will generate the following files in your current folder:

-  ./queries.md
-  ./mutations.md
-  ./objects.md
-  ./inputs.md
-  ./enums.md
-  ./scalars.md
-  ./interfaces.md
-  ./unions.md

## Documentation

Documentation is [available on Hexdocs](https://hexdocs.pm/grapqhl_markdown)

## Contributing

See [CONTRIBUTING.md](https://github.com/podium/graphql_markdown/blob/master/CONTRIBUTING.md)

## Author

Emmanuel Pinault (@epinault)

## License

Graphql Markdown is released under the MIT License. See the LICENSE file for further
details.
