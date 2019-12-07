defmodule CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Normal" do
    expect = "true\n"

    actual =
      capture_io(fn ->
        GverDiff.CLI.main([
          "2",
          "<",
          "3"
        ])
      end)

    assert expect == actual
  end

  specifiedTypeValues = [
    [:step1, "datetime", "2019-11-11 12:12:12", "2019-12-12 13:13:13"],
    [:step2, "integer", "121212", "133113"],
    [:step3, "float", "1.03", "2.04"],
    [:step4, "string", "apple", "google"],
    [:step5, "date", "2011-11-11", "2012-11-11"]
  ]

  for [label, optionType, base, target] <- specifiedTypeValues do
    @label label
    @optionType optionType
    @base base
    @target target
    test "Specified type: #{@label}" do
      expect = "true\n"

      actual =
        capture_io(fn ->
          GverDiff.CLI.main([
            "--type",
            @optionType,
            @base,
            "<",
            @target
          ])
        end)

      assert expect == actual
    end
  end

  test "Abnormal" do
    expect = "false\n"

    actual =
      capture_io(fn ->
        GverDiff.CLI.main([
          "3",
          "<",
          "2"
        ])
      end)

    assert expect == actual
  end

  test "Abnormal Operator" do
    assert_raise(
      RuntimeError,
      "Error!! undefined operator.",
      fn ->
        GverDiff.CLI.main([
          "3",
          "hoge",
          "2"
        ])
      end
    )
  end

  test "Abnormal Type" do
    assert_raise(
      RuntimeError,
      "Error!! undefined type.",
      fn ->
        GverDiff.CLI.main([
          "--type",
          "hoge",
          "3",
          "<",
          "2"
        ])
      end
    )
  end
end
