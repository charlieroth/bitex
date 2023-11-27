defmodule Bitex.CLI do
  @moduledoc """
  This module is the entry point for the CLI application.
  """
  alias Bitex.Bencode

  @spec main([binary()]) :: :ok
  def main(argv) do
    case argv do
      ["decode" | [encoded_str | _]] ->
        encoded_str
        |> Bencode.decode()
        |> Jason.encode!()
        |> IO.puts()

      [command | _] ->
        IO.puts("Unknown command: #{command}")
        System.halt(1)

      [] ->
        IO.puts("Usage: your_bittorrent.sh <command> <args>")
        System.halt(1)
    end
  end
end
