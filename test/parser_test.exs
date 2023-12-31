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

  describe "dictionaries" do
    test "simple dictionary" do
      input = [
        {:dictionary,
         %{
           {:string, "hello"} => {:string, "world"},
           {:string, "answer"} => {:integer, 42}
         }},
        :eoe
      ]

      assert %{"hello" => "world", "answer" => 42} = Parser.init(input)
    end

    test "dictionary with list" do
      input = [
        {:dictionary,
         %{
           {:string, "messages"} =>
             {:list,
              [
                {:string, "hello"},
                {:integer, 21}
              ]},
           {:string, "answer"} => {:integer, 42}
         }},
        :eoe
      ]

      assert %{"messages" => ["hello", 21], "answer" => 42} = Parser.init(input)
    end

    test "dictionary with nested lists" do
      input = [
        {:dictionary,
         %{
           {:string, "messages"} =>
             {:list,
              [
                {:string, "hello"},
                {:list,
                 [
                   {:string, "world"},
                   {:integer, 52}
                 ]}
              ]},
           {:string, "answer"} => {:integer, 42}
         }},
        :eoe
      ]

      assert %{"messages" => ["hello", ["world", 52]], "answer" => 42} = Parser.init(input)
    end

    test "dictionary with nested dictionary" do
      input = [
        {:dictionary,
         %{
           {:string, "inner_dict"} =>
             {:dictionary,
              %{
                {:string, "key1"} => {:string, "value1"},
                {:string, "key2"} => {:integer, 42},
                {:string, "list_key"} =>
                  {:list, [{:string, "item1"}, {:string, "item2"}, {:integer, 3}]}
              }}
         }},
        :eoe
      ]

      assert %{
               "inner_dict" => %{
                 "key1" => "value1",
                 "key2" => 42,
                 "list_key" => ["item1", "item2", 3]
               }
             } = Parser.init(input)
    end
  end
end
