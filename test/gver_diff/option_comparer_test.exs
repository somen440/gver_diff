defmodule OptionComparerTest do
  use ExUnit.Case

  test "compare integer" do
    values = [
#     default operator <
#     expect, base, target
      [true, 3, 4],
      [false, 4, 4],
      [false, 5, 4],
    ]
    for [expect, base, target] <- values do
      actual = GverDiff.OptionComparer.compare?([
        base: base,
        target: target,
      ])
      assert expect == actual
    end
  end
end