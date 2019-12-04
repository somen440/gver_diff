defmodule OptionComparerTest do
  use ExUnit.Case, async: true

  compareIntegerValues = [
    # default operator <
    # integer
    [:step1, %{:expect => true, :base => 3, :target => 4}],
    [:step2, %{:expect => false, :base => 4, :target => 4}],
    [:step3, %{:expect => false, :base => 5, :target => 4}],
    # sting
    [:step4, %{:expect => true, :base => "a", :target => "b"}],
    [:step5, %{:expect => false, :base => "b", :target => "b"}],
    [:step6, %{:expect => false, :base => "c", :target => "b"}],
    # float
    [:step7, %{:expect => true, :base => 3.1, :target => 3.11}],
    [:step8, %{:expect => false, :base => 4.123, :target => 4.123}],
    [:step9, %{:expect => false, :base => 5.234, :target => 4.222}],
    # date
    [
      :step10,
      %{:expect => true, :base => ~N[2019-11-11 11:11:11], :target => ~N[2019-11-11 22:22:22]}
    ],
    [
      :step11,
      %{:expect => false, :base => ~N[2019-11-11 11:11:11], :target => ~N[2019-11-11 11:11:11]}
    ],
    [
      :step12,
      %{:expect => false, :base => ~N[2019-11-11 11:11:11], :target => ~N[2019-11-09 11:11:11]}
    ],
    # different type
    [:step13, %{:expect => false, :base => 3, :target => "4"}],
    [:step14, %{:expect => false, :base => 3, :target => 3.11}]
  ]

  for [label, %{:expect => expect} = values] <- compareIntegerValues do
    @label label
    @expect expect
    @values values
    test "compare integer: #{@label}" do
      actual = @values |> GverDiff.OptionComparer.compare?(nil)
      assert @expect == actual
    end
  end

  compareSpecifiedOperatorValues = [
    # equals
    [:step1, %{:expect => true, :base => 4, :target => 4, :operator => "=="}],
    [:step2, %{:expect => false, :base => 3, :target => 4, :operator => "=="}],
    [:step3, %{:expect => false, :base => "4", :target => 4, :operator => "=="}],
    [:step4, %{:expect => true, :base => 4, :target => 4, :operator => "eq"}],
    [:step5, %{:expect => false, :base => 3, :target => 4, :operator => "eq"}],
    [:step6, %{:expect => false, :base => "4", :target => 4, :operator => "eq"}],
    # not equal
    [:step7, %{:expect => true, :base => 2, :target => 4, :operator => "!="}],
    [:step8, %{:expect => false, :base => 4, :target => 4, :operator => "!="}],
    [:step10, %{:expect => true, :base => 2, :target => 4, :operator => "<>"}],
    [:step11, %{:expect => false, :base => 4, :target => 4, :operator => "<>"}],
    [:step13, %{:expect => true, :base => 2, :target => 4, :operator => "ne"}],
    [:step14, %{:expect => false, :base => 4, :target => 4, :operator => "ne"}],
    # greater than
    [:step16, %{:expect => true, :base => 5, :target => 4, :operator => ">"}],
    [:step17, %{:expect => false, :base => 4, :target => 4, :operator => ">"}],
    [:step18, %{:expect => false, :base => 3, :target => 4, :operator => ">"}],
    [:step19, %{:expect => true, :base => 5, :target => 4, :operator => "gt"}],
    [:step20, %{:expect => false, :base => 4, :target => 4, :operator => "gt"}],
    [:step21, %{:expect => false, :base => 3, :target => 4, :operator => "gt"}],
    # less than
    [:step22, %{:expect => true, :base => 3, :target => 4, :operator => "<"}],
    [:step23, %{:expect => false, :base => 4, :target => 4, :operator => "<"}],
    [:step24, %{:expect => false, :base => 5, :target => 4, :operator => "<"}],
    [:step25, %{:expect => true, :base => 3, :target => 4, :operator => "lt"}],
    [:step26, %{:expect => false, :base => 4, :target => 4, :operator => "lt"}],
    [:step27, %{:expect => false, :base => 5, :target => 4, :operator => "lt"}],
    # greater than or equal
    [:step28, %{:expect => true, :base => 5, :target => 4, :operator => ">="}],
    [:step29, %{:expect => true, :base => 4, :target => 4, :operator => ">="}],
    [:step31, %{:expect => false, :base => 3, :target => 4, :operator => ">="}],
    [:step32, %{:expect => true, :base => 5, :target => 4, :operator => "ge"}],
    [:step33, %{:expect => true, :base => 4, :target => 4, :operator => "ge"}],
    [:step34, %{:expect => false, :base => 3, :target => 4, :operator => "ge"}],
    # less than or equal
    [:step35, %{:expect => true, :base => 5, :target => 6, :operator => "<="}],
    [:step36, %{:expect => true, :base => 4, :target => 4, :operator => "<="}],
    [:step37, %{:expect => false, :base => 3, :target => 1, :operator => "<="}],
    [:step38, %{:expect => true, :base => 5, :target => 6, :operator => "le"}],
    [:step39, %{:expect => true, :base => 4, :target => 4, :operator => "le"}],
    [:step40, %{:expect => false, :base => 3, :target => 1, :operator => "le"}]
  ]

  for [
        label,
        %{
          :expect => expect,
          :operator => operator
        } = values
      ] <- compareSpecifiedOperatorValues do
    @label label
    @expect expect
    @values values
    @operator operator
    test "compare specified oparator: #{@label}" do
      actual = @values |> GverDiff.OptionComparer.compare?(@operator)
      assert @expect == actual
    end
  end
end
