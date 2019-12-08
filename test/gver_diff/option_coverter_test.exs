defmodule OptionConverterTest do
  use ExUnit.Case, async: true

  import ExUnit.Assertions

  test "convert string to integer" do
    expect = %Compares{
      :base => 2,
      :target => 3
    }

    actual =
      GverDiff.OptionConverter.convert(
        %Compares{
          :base => "2",
          :target => "3"
        },
        []
      )

    assert expect === actual
  end

  convert_specified_type_values = [
    [
      :step1,
      %TypeAndCompares{:id => :integer, :compares => %Compares{:base => 2, :target => 3}},
      %Compares{:base => "2", :target => "3"},
      "integer"
    ],
    [
      :step2,
      %TypeAndCompares{:id => :float, :compares => %Compares{:base => 2.1, :target => 3.22}},
      %Compares{:base => "2.1", :target => "3.22"},
      "float"
    ],
    [
      :step3,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-11 11:11:11],
          :target => ~N[2019-12-12 22:22:22]
        }
      },
      %Compares{:base => "2019-11-11 11:11:11", :target => "2019-12-12 22:22:22"},
      "datetime"
    ],
    [
      :step4,
      %TypeAndCompares{
        :id => :string,
        :compares => %Compares{:base => "Apple", :target => "Banana"}
      },
      %Compares{:base => "Apple", :target => "Banana"},
      "string"
    ],
    [
      :step5,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2019-12-21], :target => ~D[2018-10-21]}
      },
      %Compares{:base => "2019-12-21", :target => "2018-10-21"},
      "date"
    ],
    [
      :step6,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.1", :target => "1.2.2"}
      },
      %Compares{:base => "1.2.1", :target => "1.2.2"},
      "version"
    ]
  ]

  for [label, expect, values, specified_type] <- convert_specified_type_values do
    @label label
    @expect expect
    @values values
    @specified_type specified_type
    test "convert specified type: #{@label}" do
      actual = GverDiff.OptionConverter.convert(@values, type: @specified_type)
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
        []
      )
    end)
  end

  convert_specified_type_with_raise_values = [
    [
      :step1,
      "not integer",
      %Compares{:base => "a", :target => "b"},
      "integer"
    ],
    [
      :step2,
      "not float",
      %Compares{:base => "a", :target => "b"},
      "float"
    ],
    [
      :step3,
      "not datetime",
      %Compares{:base => "a", :target => "b"},
      "datetime"
    ],
    [
      :step4,
      "not date",
      %Compares{:base => "a", :target => "b"},
      "date"
    ],
    [
      :step5,
      "not version",
      %Compares{:base => "1.2", :target => "1.3"},
      "version"
    ]
  ]

  for [label, message, values, specified_type] <- convert_specified_type_with_raise_values do
    @label label
    @message message
    @values values
    @specified_type specified_type
    test "covert specified type witch raise: #{label}" do
      assert_raise(RuntimeError, @message, fn ->
        GverDiff.OptionConverter.convert(
          @values,
          type: @specified_type
        )
      end)
    end
  end

  convert_specified_type_with_raise_values = [
    [
      :step1,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2011-10-11], :target => ~D[2011-12-12]}
      },
      %Compares{:base => "dev-20111011", :target => "dev-20111212"},
      "date",
      "dev-(?<version>.*)"
    ]
  ]

  for [label, expect, values, specified_type, regex] <- convert_specified_type_with_raise_values do
    @label label
    @expect expect
    @values values
    @specified_type specified_type
    @regex regex
    test "covert specified regex: #{label}" do
      actual =
        GverDiff.OptionConverter.convert(
          @values,
          type: @specified_type,
          regex: @regex
        )

      assert @expect === actual
    end
  end

  test "convert specified regex with raise" do
    assert_raise(RuntimeError, "Error!! failed extract regex.", fn ->
      GverDiff.OptionConverter.convert(
        %Compares{:base => "11", :target => "22"},
        type: "date",
        regex: "dev-(?<version>.*"
      )
    end)
  end
end
