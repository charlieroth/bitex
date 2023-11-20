defmodule Bitex.Bencode do
  def decode(input) when is_binary(input) do
    input
    |> Bitex.Lexer.init()
    |> Bitex.Parser.init()
  end
end
