defmodule Bitex.CLI do
  @moduledoc """
  This module is the entry point for the CLI application.
  """
  alias Bitex.Bencode

  @spec main([binary()]) :: :ok
  def main(argv) do
    case argv do
      ["decode" | [encoded_str | _]] ->
        # You can use print statements as follows for debugging, they'll be visible when running tests.
        # IO.puts("Logs from your program will appear here!")

        # Uncomment this block to pass the first stage
        decoded_str = Bencode.decode(encoded_str)
        IO.puts(Jason.encode!(decoded_str))
      [command | _] ->
        IO.puts("Unknown command: #{command}")
          System.halt(1)
      [] ->
        IO.puts("Usage: your_bittorrent.sh <command> <args>")
        System.halt(1)
    end
  end
end
