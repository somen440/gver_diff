defmodule GverDiff.OptionConverter do
  def convert(%{:base => base, :target => target}, []) do
    %{
      :base => convert_integer(base),
      :target => convert_integer(target)
    }
  end

  def convert(
        %{:base => base, :target => target} = values,
        [{:type, type}]
      ) do
    cond do
      type === "string" ->
        {:string,
         %{
           :base => base,
           :target => target
         }}

      type === "integer" ->
        {:integer,
         %{
           :base => convert_integer(base),
           :target => convert_integer(target)
         }}

      type === "float" ->
        {:float,
         %{
           :base => convert_float(base),
           :target => convert_float(target)
         }}

      type === "datetime" ->
        {:datetime,
         %{
           :base => convert_datetime(base),
           :target => convert_datetime(target)
         }}

      type == "date" ->
        {:date,
         %{
           :base => convert_date(base),
           :target => convert_date(target)
         }}

      type == "version" ->
        {:version,
         %{
           :base => convert_version(base),
           :target => convert_version(target)
         }}

      true ->
        raise "Error!! undefined type."
    end
  end

  def convert(
        %{:base => base, :target => target},
        [{:type, type}, {:regex, regex}]
      ) do
    extract_version = fn x ->
      regex
      |> Regex.compile()
      |> case do
        {:ok, r} ->
          r |> Regex.named_captures(x)

        {:error, _} ->
          raise "Error!! failed extract regex."
      end
      |> Map.fetch!("version")
    end

    convert(
      %{:base => extract_version.(base), :target => extract_version.(target)},
      type: type
    )
  end

  defp convert_integer(x) do
    case Integer.parse(x) do
      {x, _} -> x
      :error -> raise "not integer"
    end
  end

  defp convert_float(x) do
    case Float.parse(x) do
      {x, _} -> x
      :error -> raise "not float"
    end
  end

  defp convert_datetime(x) do
    case NaiveDateTime.from_iso8601(x) do
      {:ok, datetime} -> datetime
      {:error, _} -> raise "not datetime"
    end
  end

  defp convert_date(x) do
    # 20191011 -> 2019-10-11
    convert = fn from ->
      case Date.from_iso8601(from) do
        {:ok, date} -> date
        {:error, _} -> raise "not date"
      end
    end

    if Regex.match?(~r/20[0-9]{6}/, x) do
      capture =
        Regex.named_captures(
          ~r/(?<year>[0-9]{4})(?<date>[0-9]{2})(?<day>[0-9]{2})/,
          x
        )

      [capture["year"], capture["date"], capture["day"]]
      |> Enum.join("-")
      |> convert.()
    else
      convert.(x)
    end
  end

  defp convert_version(x) do
    if Regex.match?(~r/\d+\.\d+\.\d+/, x) do
      x
    else
      raise "not version"
    end
  end
end
