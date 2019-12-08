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

    %Compares{:base => base, :target => target}
    |> GverDiff.OptionConverter.convert(options)
    |> GverDiff.OptionComparer.compare?(operator)
    |> IO.puts()
  end
end
