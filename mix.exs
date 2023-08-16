defmodule GraphqlMarkdown.MixProject do
  use Mix.Project

  @project_url "https://github.com/podium/graphql_markdown"

  def project do
    [
      app: :graphql_markdown,
      name: "Graphql Markdown",
      description: "A simple GraphQL JSON Schema to  Markdown generator",
      version: "0.1.3",
      elixir: "~> 1.11",
      source_url: @project_url,
      homepage_url: @project_url,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [summary: [threshold: 85]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.25", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.2"}
    ]
  end

  defp docs do
    [
      main: "GraphqlMarkdown"
    ]
  end

  defp package do
    [
      maintainers: ["Emmanuel Pinault"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @project_url,
        "Changelog" => "#{@project_url}/blob/master/CHANGELOG.md"
      }
    ]
  end
end
