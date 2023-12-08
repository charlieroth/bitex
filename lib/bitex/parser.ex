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

  def parse([{:dictionary, dict} | rest], results) do
    result =
      Enum.reduce(dict, %{}, fn {key, value}, acc ->
        parsed_value = parse(value)

        if is_list(parsed_value) and Enum.count(parsed_value) == 1 do
          Map.put(acc, parse(key), Enum.at(parsed_value, 0))
        else
          Map.put(acc, parse(key), parsed_value)
        end
      end)

    parse(rest, [result | results])
  end

  def parse([{:list, tokens} | rest], results) do
    parsed_list = parse({:list, tokens})
    parse(rest, [parsed_list | results])
  end

  def parse([{:integer, value} | rest], results) do
    parsed_integer = parse({:integer, value})
    parse(rest, [parsed_integer | results])
  end

  def parse([{:string, value} | rest], results) do
    parsed_string = parse({:string, value})
    parse(rest, [parsed_string | results])
  end

  def parse({:list, tokens}) do
    Enum.map(tokens, &parse/1)
  end

  def parse({:dictionary, key}) do
    result =
      Enum.reduce(key, %{}, fn {key, value}, acc ->
        parsed_value = parse(value)

        if is_list(parsed_value) and Enum.count(parsed_value) == 1 do
          Map.put(acc, parse(key), Enum.at(parsed_value, 0))
        else
          Map.put(acc, parse(key), parsed_value)
        end
      end)

    result
  end

  def parse({:string, key}), do: key

  def parse({:integer, key}), do: key
end
