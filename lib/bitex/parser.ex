defmodule Bitex.Parser do
  alias Bitex.Token

  @spec init([Token.t()]) :: any()
  def init(tokens) do
    result = parse(tokens, []) |> Enum.reverse()
    if Enum.count(result) == 1 do
      Enum.at(result, 0)
    else
      result
    end
  end

  @spec parse([Token.t()], [any()]) :: [any()]
  def parse([], results), do: results |> Enum.reverse()

  def parse([:eoe | _], results), do: results

  def parse([{:list, tokens} | rest], results) do
    result = parse(tokens, [])
    parse(rest, [result | results])
  end

  def parse([{:integer, value} | rest], results) do
    parse(rest, [value | results])
  end

  def parse([{:string, value} | rest], results) do
    parse(rest, [value | results])
  end
end
