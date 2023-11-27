defmodule Bitex.PaserTest do
  use ExUnit.Case
  alias Bitex.Parser

  describe "strings" do
    test "single string" do
      input = [
        {:string, "hello"},
        :eoe
      ]

      assert "hello" = Parser.init(input)
    end
  end

  describe "integers" do
    test "positive integer" do
      input = [
        {:integer, 42},
        :eoe
      ]

      assert 42 = Parser.init(input)
    end

    test "negative integer" do
      input = [
        {:integer, -42},
        :eoe
      ]

      assert -42 = Parser.init(input)
    end
  end

  describe "lists" do
    test "single list" do
      input = [
        {:list,
         [
           {:string, "hello"},
           {:integer, 52}
         ]},
        :eoe
      ]

      assert ["hello", 52] = Parser.init(input)
    end

    test "nested lists" do
      input = [
        {:list,
         [
           {:string, "hello"},
           {:list,
            [
              {:string, "world"},
              {:integer, 52}
            ]}
         ]},
        :eoe
      ]

      assert ["hello", ["world", 52]] = Parser.init(input)
    end
  end
end
