defmodule ResolverWorkerTest do
  use ExUnit.Case
  doctest ResolverWorker

  test "greets the world" do
    assert ResolverWorker.hello() == :world
  end
end
