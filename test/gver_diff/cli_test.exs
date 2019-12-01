defmodule CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Normal" do
    expect = "OK !!\n"

    actual =
      capture_io(fn ->
        GverDiff.CLI.main([
          "--base",
          "2",
          "--target",
          "3"
        ])
      end)

    assert expect == actual
  end

  test "Abnormal" do
    expect = 1

    {_, actual} =
      GverDiff.CLI.main([
        "--base",
        "3",
        "--target",
        "2"
      ])
      |> catch_exit

    assert expect == actual
  end
end
