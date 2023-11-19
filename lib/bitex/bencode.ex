defmodule Bitex.Bencode do
  def decode(encoded_value) when is_binary(encoded_value), do: decode_type(encoded_value)

  def decode(_), do: "Invalid encoded value: not binary"

  # decode an integer
  def decode_type("i" <> rest) do
    rest
    |> String.split("e", trim: true)
    |> List.first()
    |> String.to_integer()
  end

  # decode a string
  def decode_type(value) do
    [length, string] = String.split(value, ":", parts: 2, trim: true)
    String.slice(string, 0, String.to_integer(length))
  end
end
