defmodule Bitex.Token do
  @type t() ::
          {:string, String.t()}
          | {:integer, integer()}
          | {:list, list()}
          | {:dictionary, map()}
end
