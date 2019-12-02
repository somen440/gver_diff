defmodule OptionComparerTest do
  use ExUnit.Case

  test "compare integer" do
    Enum.each(
      [
        # default operator <
        %{:expect => true, :base => 3, :target => 4},
        %{:expect => false, :base => 4, :target => 4},
        %{:expect => false, :base => 5, :target => 4}
      ],
      fn %{:expect => expect} = values ->
        actual = values |> GverDiff.OptionComparer.compare?()
        assert expect == actual
      end
    )
  end
end
