defmodule GraphqlMarkdown.Renderer do
  @moduledoc """
  A Genserver to renderer message to stiod by default or to file if specifying a filename when starting
  """
  use GenServer

  def start_link(options \\ []) do
    name = Keyword.get(options, :name, :default_renderer)

    # We now start the GenServer with a `name` option.
    GenServer.start_link(__MODULE__, options, name: String.to_existing_atom(name))
  end

  def render(message, renderer \\ :default_renderer) do
    GenServer.call(renderer, {:text, message})
  end

  def render_newline(renderer \\ :default_renderer) do
    GenServer.call(renderer, :new_line)
  end

  def save(renderer \\ :default_renderer) do
    GenServer.call(renderer, :save)
  end

  # SERVER

  def init(options) do
    state =
      case options[:filename] do
        nil ->
          %{fileio: :stdio}

        filename ->
          fileio = File.open!(filename, [:write])
          %{fileio: fileio, filename: filename}
      end

    {:ok, state}
  end

  def handle_call({:text, text}, _from, %{fileio: fileio} = state) do
    IO.write(fileio, text <> "\n")
    {:reply, :ok, state}
  end

  def handle_call(:new_line, _from, %{fileio: fileio} = state) do
    IO.write(fileio, "\n")
    {:reply, :ok, state}
  end

  def handle_call(:save, _from, %{fileio: fileio} = state) do
    case fileio do
      :stdio ->
        {:reply, :ok, %{state | fileio: nil}}

      _ ->
        File.close(fileio)
        {:stop, :normal, :ok, %{state | fileio: nil}}
    end
  end
end
