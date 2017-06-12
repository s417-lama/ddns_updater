defmodule CliTest do
  use ExUnit.Case
  doctest DdnsUpdater

  import DdnsUpdater.CLI, only: [ parse_args: 1 ]

  test ":help returned" do
    assert parse_args(["-h", "aaa"]) == :help
    assert parse_args(["--help", "aaa"]) == :help
    assert parse_args(["aaa", "bbb"]) == :help
    assert parse_args(["aaa", "bbb", "ccc", "ddd", "eee"]) == :help
  end

  test "when the number of args is four" do
    assert parse_args(["aaa", "bbb", "ccc", "100"]) ==
      {"aaa", "bbb", "ccc", 100}
  end

  test "check the default value" do
    assert parse_args(["aaa", "bbb", "ccc"]) ==
      {"aaa", "bbb", "ccc", 10}
  end
  
end

