defmodule Bitex.MixProject do
  # NOTE: You do not need to change anything in this file.
  use Mix.Project

  def project do
    [
      app: :bitex,
      version: "1.0.0",
      escript: [main_module: Bitex.CLI],
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
    ]
  end
end
