defmodule GverDiff.CLI do
  def main(args) do
    {options, arg, _} =
      OptionParser.parse(
        args,
        strict: [
          type: :string
        ],
        aliases: [
          t: :type
        ]
      )

    [base, operator, target] = arg

    %{:base => base, :target => target}
    |> GverDiff.OptionConverter.convert(options[:type])
    |> GverDiff.OptionComparer.compare?(operator)
    |> IO.puts()
  end
end
