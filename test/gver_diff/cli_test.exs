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

  test "Specified Type" do
    expect = "true\n"

    actual =
      capture_io(fn ->
        GverDiff.CLI.main([
          "--type",
          "datetime",
          "2019-11-11 12:12:12",
          "<",
          "2019-12-12 13:13:13"
        ])
      end)

    assert expect == actual
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
    expect = "false\n"

    actual =
      capture_io(fn ->
        GverDiff.CLI.main([
          "3",
          "hoge",
          "2"
        ])
      end)

    assert expect == actual
  end
end
