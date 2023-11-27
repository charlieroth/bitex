defmodule Bitex.LexerTest do
  use ExUnit.Case
  alias Bitex.Lexer

  describe "strings" do
    test "lex single string" do
      input = "5:hello"

      assert [
               {:string, "hello"},
               :eoe
             ] = Lexer.init(input)
    end
  end

  describe "integers" do
    test "positive integer" do
      input = "i42e"

      assert [
               {:integer, 42},
               :eoe
             ] = Lexer.init(input)
    end

    test "negative integer" do
      input = "i-42e"

      assert [
               {:integer, -42},
               :eoe
             ] = Lexer.init(input)
    end
  end

  describe "lists" do
    test "single list" do
      input = "l5:helloi52ee"

      assert [
               {:list,
                [
                  {:string, "hello"},
                  {:integer, 52}
                ]},
               :eoe
             ] = Lexer.init(input)
    end

    test "nested lists" do
      input = "l5:hellol5:worldi52eee"

      assert [
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
             ] = Lexer.init(input)
    end
  end
end
