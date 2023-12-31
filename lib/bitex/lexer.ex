defmodule Bitex.Lexer do
  alias Bitex.Token

  defguardp is_integer_character(ch) when ch in ?0..?9 or ch == ?-

  @spec init(input :: String.t()) :: [Token.t()]
  def init(input) when is_binary(input), do: lex(input, [])

  @spec lex(String.t(), [Token.t()]) :: [Token.t()]
  def lex(<<>>, tokens), do: [:eoe | tokens] |> Enum.reverse()

  def lex(input, tokens) do
    {token, rest} = tokenize(input)
    lex(rest, [token | tokens])
  end

  @spec tokenize(String.t()) :: {Token.t(), String.t()}
  defp tokenize(<<"d", rest::binary>>) do
    read_dictionary(rest, %{})
  end

  defp tokenize(<<"l", rest::binary>>) do
    read_list(rest, [])
  end

  defp tokenize(<<"i", rest::binary>>) do
    read_integer(rest, <<>>)
  end

  defp tokenize(input) do
    read_string(input)
  end

  @spec read_dictionary(String.t(), map()) :: {Token.t(), String.t()}
  def read_dictionary(input, acc) do
    case input do
      "e" <> rest ->
        {{:dictionary, acc}, rest}

      rest ->
        {key, rest} = read_string(rest)
        {value, rest} = tokenize(rest)
        read_dictionary(rest, Map.put(acc, key, value))
    end
  end

  @spec read_list(String.t(), [Token.t()]) :: {Token.t(), String.t()}
  def read_list(input, acc) do
    case input do
      "e" <> rest ->
        {{:list, Enum.reverse(acc)}, rest}

      rest ->
        {token, rest} = tokenize(rest)
        read_list(rest, [token | acc])
    end
  end

  @spec read_integer(String.t(), binary()) :: {Token.t(), String.t()}
  def read_integer("e" <> rest, acc) do
    {{:integer, String.to_integer(acc)}, rest}
  end

  def read_integer(<<ch::8, rest::binary>>, acc) when is_integer_character(ch) do
    read_integer(rest, <<acc::binary, ch::utf8>>)
  end

  @spec read_string(String.t()) :: {Token.t(), String.t()}
  def read_string(input) do
    [len, rest] = String.split(input, ":", parts: 2, trim: true)
    len = String.to_integer(len)
    {string, rest} = String.split_at(rest, len)
    {{:string, string}, rest}
  end
end
