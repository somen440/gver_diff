defmodule GverDiff.OptionConverter do
  def convert(%{:base => base, :target => target}, nil) do
    %{
      :base => convert_integer(base),
      :target => convert_integer(target)
    }
  end

  def convert(%{:base => base, :target => target} = values, type) do
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
    case Date.from_iso8601(x) do
      {:ok, date} -> date
      {:error, _} -> raise "not date"
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
