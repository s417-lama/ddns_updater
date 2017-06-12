defmodule CliTest do
  use ExUnit.Case
  doctest DdnsUpdater

  import DdnsUpdater.CLI, only: [ parse_args: 1 ]

  test ":help returned" do
    assert parse_args(["-h", "aaa"]) == :help
    assert parse_args(["--help", "aaa"]) == :help
    assert parse_args(["aaa", "bbb"]) == :help
    assert parse_args(["aaa", "bbb", "ccc", "ddd"]) == :help
  end

  test "when the number of args is correct" do
    assert parse_args(["aaa", "bbb", "ccc"]) == {"aaa", "bbb", "ccc"}
  end
  
end

