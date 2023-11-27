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

  describe "dictionaries" do
    test "only dictionary" do
      input = "d3:foo3:bar5:helloi52ee"

      assert [
               {:dictionary,
                %{{:string, "foo"} => {:string, "bar"}, {:string, "hello"} => {:integer, 52}}},
               :eoe
             ] = Lexer.init(input)
    end

    test "dictionary with list" do
      input = "d3:foo3:bar5:hellol5:worldi52eee"

      assert [
               {:dictionary,
                %{
                  {:string, "foo"} => {:string, "bar"},
                  {:string, "hello"} => {:list, [{:string, "world"}, {:integer, 52}]}
                }},
               :eoe
             ] = Lexer.init(input)
    end

    test "dictionary with nested lists" do
      input = "d3:foo3:bar5:hellol5:worldl5:universeli42eee"

      assert [
               {:dictionary,
                %{
                  {:string, "foo"} => {:string, "bar"},
                  {:string, "hello"} =>
                    {:list,
                     [{:string, "world"}, {:list, [{:string, "universe"}, {:integer, 42}]}]}
                }},
               :eoe
             ] = Lexer.init(input)
    end
  end
end
