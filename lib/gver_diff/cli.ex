defmodule GverDiff.CLI do
  def main(args) do
    {options, arg, _} =
      OptionParser.parse(
        args,
        strict: [
          type: :string,
          regex: :string
        ],
        aliases: [
          t: :type,
          r: :regex
        ]
      )

    [base, operator, target] = arg

    option = options
      |> Enum.map(fn {k, v} ->
        if k == :type do
          GverDiffType.new(v)
        else
          {:k, v}
        end
      end)

    %Compares{:base => base, :target => target}
    |> GverDiff.OptionConverter.convert(option)
    |> GverDiff.OptionComparer.compare?(operator)
    |> IO.puts()
  end
end
