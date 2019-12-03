defmodule GverDiff.CLI do
  def main(args) do
    {options, _, _} =
      OptionParser.parse(
        args,
        strict: [
          base: :string,
          target: :string,
          type: :string,
          operator: :string
        ],
        aliases: [
          t: :type,
          o: :operator
        ]
      )

    options
    |> Enum.into(%{})
    |> GverDiff.OptionConverter.convert()
    |> GverDiff.OptionComparer.compare?(options[:operator])
    |> if do
      IO.puts("OK !!")
    else
      IO.puts("Error !!")
      exit({:shutdown, 1})
    end
  end
end
