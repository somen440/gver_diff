defmodule OptionComparerTest do
  use ExUnit.Case, async: true

  compare_integer_values = [
    # default operator <
    # integer
    [:step1, true, %Compares{:base => 3, :target => 4}],
    [:step2, false, %Compares{:base => 4, :target => 4}],
    [:step3, false, %Compares{:base => 5, :target => 4}],
    # sting
    [:step4, true, %Compares{:base => "a", :target => "b"}],
    [:step5, false, %Compares{:base => "b", :target => "b"}],
    [:step6, false, %Compares{:base => "c", :target => "b"}],
    # float
    [:step7, true, %Compares{:base => 3.1, :target => 3.11}],
    [:step8, false, %Compares{:base => 4.123, :target => 4.123}],
    [:step9, false, %Compares{:base => 5.234, :target => 4.222}],
    # datetime
    [
      :step10,
      true,
      %Compares{:base => ~N[2019-11-11 11:11:11], :target => ~N[2019-11-11 22:22:22]}
    ],
    [
      :step11,
      false,
      %Compares{:base => ~N[2019-11-11 11:11:11], :target => ~N[2019-11-11 11:11:11]}
    ],
    [
      :step12,
      false,
      %Compares{:base => ~N[2019-11-11 11:11:11], :target => ~N[2019-11-09 11:11:11]}
    ],
    # different type
    [:step13, false, %Compares{:base => 3, :target => "4"}],
    [:step14, false, %Compares{:base => 3, :target => 3.11}],
    # date
    [
      :step15,
      true,
      %Compares{:base => ~D[2019-11-11], :target => ~D[2019-11-12]}
    ],
    [
      :step16,
      false,
      %Compares{:base => ~D[2019-11-11], :target => ~D[2019-11-11]}
    ],
    [
      :step17,
      false,
      %Compares{:base => ~D[2019-11-11], :target => ~D[2019-11-09]}
    ]
  ]

  for [label, expect, values] <- compare_integer_values do
    @label label
    @expect expect
    @values values
    test "compare integer: #{@label}" do
      actual = @values |> GverDiff.OptionComparer.compare?(nil)
      assert @expect == actual
    end
  end

  compare_specified_operator_values = [
    # equals
    [:step1, true, %Compares{:base => 4, :target => 4}, "=="],
    [:step2, false, %Compares{:base => 3, :target => 4}, "=="],
    [:step3, false, %Compares{:base => "4", :target => 4}, "=="],
    [:step4, true, %Compares{:base => 4, :target => 4}, "eq"],
    [:step5, false, %Compares{:base => 3, :target => 4}, "eq"],
    [:step6, false, %Compares{:base => "4", :target => 4}, "eq"],
    # not equal
    [:step7, true, %Compares{:base => 2, :target => 4}, "!="],
    [:step8, false, %Compares{:base => 4, :target => 4}, "!="],
    [:step10, true, %Compares{:base => 2, :target => 4}, "<>"],
    [:step11, false, %Compares{:base => 4, :target => 4}, "<>"],
    [:step13, true, %Compares{:base => 2, :target => 4}, "ne"],
    [:step14, false, %Compares{:base => 4, :target => 4}, "ne"],
    # greater than
    [:step16, true, %Compares{:base => 5, :target => 4}, ">"],
    [:step17, false, %Compares{:base => 4, :target => 4}, ">"],
    [:step18, false, %Compares{:base => 3, :target => 4}, ">"],
    [:step19, true, %Compares{:base => 5, :target => 4}, "gt"],
    [:step20, false, %Compares{:base => 4, :target => 4}, "gt"],
    [:step21, false, %Compares{:base => 3, :target => 4}, "gt"],
    # less than
    [:step22, true, %Compares{:base => 3, :target => 4}, "<"],
    [:step23, false, %Compares{:base => 4, :target => 4}, "<"],
    [:step24, false, %Compares{:base => 5, :target => 4}, "<"],
    [:step25, true, %Compares{:base => 3, :target => 4}, "lt"],
    [:step26, false, %Compares{:base => 4, :target => 4}, "lt"],
    [:step27, false, %Compares{:base => 5, :target => 4}, "lt"],
    # greater than or equal
    [:step28, true, %Compares{:base => 5, :target => 4}, ">="],
    [:step29, true, %Compares{:base => 4, :target => 4}, ">="],
    [:step31, false, %Compares{:base => 3, :target => 4}, ">="],
    [:step32, true, %Compares{:base => 5, :target => 4}, "ge"],
    [:step33, true, %Compares{:base => 4, :target => 4}, "ge"],
    [:step34, false, %Compares{:base => 3, :target => 4}, "ge"],
    # less than or equal
    [:step35, true, %Compares{:base => 5, :target => 6}, "<="],
    [:step36, true, %Compares{:base => 4, :target => 4}, "<="],
    [:step37, false, %Compares{:base => 3, :target => 1}, "<="],
    [:step38, true, %Compares{:base => 5, :target => 6}, "le"],
    [:step39, true, %Compares{:base => 4, :target => 4}, "le"],
    [:step40, false, %Compares{:base => 3, :target => 1}, "le"],
    # date
    [
      :step41,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2019-10-11], :target => ~D[2020-10-11]}
      },
      "<"
    ],
    [
      :step42,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2019-10-11], :target => ~D[2019-11-11]}
      },
      "<"
    ],
    [
      :step43,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2019-10-11], :target => ~D[2019-10-12]}
      },
      "<"
    ],
    [
      :step44,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2019-10-11], :target => ~D[2019-10-12]}
      },
      "<"
    ],
    [
      :step45,
      false,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2019-10-12]}
      },
      "<"
    ],
    [
      :step46,
      false,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2019-10-12]}
      },
      "eq"
    ],
    [
      :step47,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-10-11]}
      },
      "eq"
    ],
    [
      :step48,
      false,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-10-11]}
      },
      "<>"
    ],
    [
      :step49,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-11-11]}
      },
      "<>"
    ],
    [
      :step50,
      false,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-11-11]}
      },
      ">"
    ],
    [
      :step51,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-09-11]}
      },
      ">"
    ],
    [
      :step52,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-09-11]}
      },
      ">="
    ],
    [
      :step53,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-10-11]}
      },
      ">="
    ],
    [
      :step54,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2021-10-11]}
      },
      "<="
    ],
    [
      :step55,
      true,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2020-10-11]}
      },
      "<="
    ],
    [
      :step56,
      false,
      %TypeAndCompares{
        :id => :date,
        :compares => %Compares{:base => ~D[2020-10-11], :target => ~D[2019-10-11]}
      },
      "<="
    ],
    # datetime
    [
      :step57,
      true,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-28 14:59:08],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      "<="
    ],
    [
      :step58,
      true,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-28 14:59:08],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      "<"
    ],
    [
      :step59,
      true,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-28 14:59:08],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      "!="
    ],
    [
      :step60,
      false,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-28 14:59:08],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      ">="
    ],
    [
      :step61,
      false,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-28 14:59:08],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      ">"
    ],
    [
      :step62,
      false,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-11-28 14:59:08],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      "=="
    ],
    [
      :step63,
      true,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-12-07 15:40:59],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      "=="
    ],
    [
      :step64,
      true,
      %TypeAndCompares{
        :id => :datetime,
        :compares => %Compares{
          :base => ~N[2019-12-07 15:41:59],
          :target => ~N[2019-12-07 15:40:59]
        }
      },
      ">"
    ]
  ]

  for [label, expect, values, operator] <-
        compare_specified_operator_values do
    @label label
    @expect expect
    @values values
    @operator operator
    test "compare specified oparator: #{@label}" do
      actual = @values |> GverDiff.OptionComparer.compare?(@operator)
      assert @expect == actual
    end
  end

  compare_version = [
    [
      :step1,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.3", :target => "1.2.3"}
      },
      "eq"
    ],
    [
      :step2,
      false,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.3", :target => "1.2.4"}
      },
      "eq"
    ],
    [
      :step3,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.3", :target => "1.2.4"}
      },
      "ne"
    ],
    [
      :step4,
      false,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.4", :target => "1.2.4"}
      },
      "ne"
    ],
    [
      :step5,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.15", :target => "1.2.4"}
      },
      "gt"
    ],
    [
      :step6,
      false,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.15", :target => "1.3.4"}
      },
      "gt"
    ],
    [
      :step7,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.1.15", :target => "1.2.4"}
      },
      "lt"
    ],
    [
      :step8,
      false,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "2.3.15", :target => "1.3.4"}
      },
      "lt"
    ],
    [
      :step9,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.4", :target => "1.2.4"}
      },
      "ge"
    ],
    [
      :step10,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "2.3.15", :target => "1.3.4"}
      },
      "ge"
    ],
    [
      :step11,
      false,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "0.3.15", :target => "1.3.4"}
      },
      "ge"
    ],
    [
      :step12,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "1.2.4", :target => "1.2.4"}
      },
      "le"
    ],
    [
      :step13,
      true,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "0.3.15", :target => "1.3.4"}
      },
      "le"
    ],
    [
      :step14,
      false,
      %TypeAndCompares{
        :id => :version,
        :compares => %Compares{:base => "2.3.15", :target => "1.3.4"}
      },
      "le"
    ]
  ]

  for [label, expect, values, operator] <- compare_version do
    @label label
    @expect expect
    @values values
    @operator operator
    test "compare version: #{@label}" do
      actual = @values |> GverDiff.OptionComparer.compare?(@operator)
      assert @expect === actual
    end
  end
end
