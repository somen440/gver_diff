defmodule OptionConverterTest do
  use ExUnit.Case, async: true

  import ExUnit.Assertions

  test "convert string to integer" do
    expect = %{
      :base => 2,
      :target => 3
    }

    actual =
      GverDiff.OptionConverter.convert(
        %{
          :base => "2",
          :target => "3"
        },
        nil
      )

    assert expect == actual
  end

  convertSpecifiedTypeValues = [
    [
      :step1,
      {:integer, %{:base => 2, :target => 3}},
      %{:base => "2", :target => "3"},
      "integer"
    ],
    [
      :step2,
      {:float, %{:base => 2.1, :target => 3.22}},
      %{:base => "2.1", :target => "3.22"},
      "float"
    ],
    [
      :step3,
      {:datetime, %{:base => ~N[2019-11-11 11:11:11], :target => ~N[2019-12-12 22:22:22]}},
      %{:base => "2019-11-11 11:11:11", :target => "2019-12-12 22:22:22"},
      "datetime"
    ],
    [
      :step4,
      {:string, %{:base => "Apple", :target => "Banana"}},
      %{:base => "Apple", :target => "Banana"},
      "string"
    ],
    [
      :step5,
      {:date, %{:base => ~D[2019-12-21], :target => ~D[2018-10-21]}},
      %{:base => "2019-12-21", :target => "2018-10-21"},
      "date"
    ],
    [
      :step6,
      {:version, %{:base => "1.2.1", :target => "1.2.2"}},
      %{:base => "1.2.1", :target => "1.2.2"},
      "version"
    ]
  ]

  for [label, expect, values, specifiedType] <- convertSpecifiedTypeValues do
    @label label
    @expect expect
    @values values
    @specifiedType specifiedType
    test "convert specified type: #{@label}" do
      actual = GverDiff.OptionConverter.convert(@values, @specifiedType)
      assert @expect === actual
    end
  end

  test "convert string to integer with raise" do
    assert_raise(RuntimeError, "not integer", fn ->
      GverDiff.OptionConverter.convert(
        %{
          :base => "a",
          :target => "b"
        },
        nil
      )
    end)
  end

  convertSpecifiedTypeWithRaiseValues = [
    [
      :step1,
      "not integer",
      %{:base => "a", :target => "b"},
      "integer"
    ],
    [
      :step2,
      "not float",
      %{:base => "a", :target => "b"},
      "float"
    ],
    [
      :step3,
      "not datetime",
      %{:base => "a", :target => "b"},
      "datetime"
    ],
    [
      :step4,
      "not date",
      %{:base => "a", :target => "b"},
      "date"
    ],
    [
      :step5,
      "not version",
      %{:base => "1.2", :target => "1.3"},
      "version"
    ]
  ]

  for [label, message, values, specifiedType] <- convertSpecifiedTypeWithRaiseValues do
    @label label
    @message message
    @values values
    @specifiedType specifiedType
    test "covert specified type witch raise: #{label}" do
      assert_raise(RuntimeError, @message, fn ->
        GverDiff.OptionConverter.convert(
          @values,
          @specifiedType
        )
      end)
    end
  end
end
