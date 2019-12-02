defmodule OptionConverterTest do
  use ExUnit.Case

  test "convert string to integer" do
    expect = %{
      :base => 2,
      :target => 3
    }

    actual =
      GverDiff.OptionConverter.convert({
        [
          base: "2",
          target: "3"
        ],
        1,
        2
      })

    assert expect == actual
  end
end
