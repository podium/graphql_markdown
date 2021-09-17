defmodule Mix.Tasks.GraphqlGenMarkdown do
  @shortdoc "Transform a GraphQL JSON schema to markdown"

  @moduledoc """
    A mix task to convert a GraphQL JSON schema to markdown

    usage
    -----

    mix refresh_token.cleanup [OPTIONS]

    valid override args:
      -f, --schema            Path to the schema file
      -o, --outpout-dir       Where to output the files. Default: [Current Directory]
      -m, --multi-page        Generate each type in a separate file. Default: [single page format]
      -t, --title             Specify the page title for the generated file (Applies to single file only)
      --no-toc                Do not generate the table of content (Applies to single file only)


    Examples
    --------

    1. Convert the GraphQL JSON schema to a single markdown file

    mix grapqhl.gen.markdown -f myschema.json

    2. Convert the GraphQL JSON schema to a multiple markdown file

    mix grapqhl.gen.markdown -f myschema.json -m

  """

  @shortdoc "Convert a GraphQL JSON schema to markdown files"
  use Mix.Task

  @args [
    schema: :string,
    output_dir: :string,
    multi_page: :boolean,
    title: :string,
    no_toc: :boolean
  ]

  @args_aliases [
    f: :schema,
    o: :output_dir,
    m: :multi_page,
    t: :title
  ]

  @doc false
  def run(args) do
    {parsed_args, _} = OptionParser.parse!(args, aliases: @args_aliases, strict: @args)

    GraphqlMarkdown.generate(parsed_args)
  end
end
