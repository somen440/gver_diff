defmodule GverDiff.CLI do
  def main(args) do
    OptionParser.parse(
      args,
      strict: [
        base: :string,
        target: :string
      ]
    )
    |> GverDiff.OptionConverter.convert()
    |> GverDiff.OptionComparer.compare?()
    |> if do
      IO.puts("OK !!")
    else
      IO.puts("Error !!")
      exit({:shutdown, 1})
    end
  end
end
