defmodule GverDiff.OptionConverter do
  def convert(%{:base => base, :target => target}, nil) do
    %{
      :base => convert_integer(base),
      :target => convert_integer(target)
    }
  end

  def convert(%{:base => base, :target => target} = values, type) do
    cond do
      type === "integer" ->
        %{
          :base => convert_integer(base),
          :target => convert_integer(target)
        }

      type === "float" ->
        %{
          :base => convert_float(base),
          :target => convert_float(target)
        }

      type === "datetime" ->
        %{
          :base => convert_datetime(base),
          :target => convert_datetime(target)
        }

      true ->
        values
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
end
