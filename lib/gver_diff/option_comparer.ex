defmodule GverDiff.OptionComparer do
  def compare?(%{:base => base, :target => target}, nil) do
    cond do
      get_type(base) === get_type(target) -> base < target
      true -> false
    end
  end

  def compare?(%{:base => base, :target => target}, operator) do
    cond do
      get_type(base) === get_type(target) ->
        case check_operator(operator) do
          {:equal} -> base === target
          {:notEqual} -> base !== target
          {:greaterThan} -> base > target
          {:lessThan} -> base < target
          {:greaterThanOrEqual} -> base >= target
          {:lessThanOrEqual} -> base <= target
          {:error} -> raise "Error!! undefined operator."
        end

      true ->
        false
    end
  end

  def compare?({:string, values}, operator), do: values |> compare?(operator)
  def compare?({:integer, values}, operator), do: values |> compare?(operator)
  def compare?({:float, values}, operator), do: values |> compare?(operator)
  def compare?({:datetime, values}, operator), do: values |> compare?(operator)
  def compare?({:date, values}, operator), do: values |> compare?(operator)

  defp check_operator(operator) do
    cond do
      operator == "==" or operator == "eq" -> {:equal}
      operator == "!=" or operator == "ne" or operator == "<>" -> {:notEqual}
      operator == ">" or operator == "gt" -> {:greaterThan}
      operator == "<" or operator == "lt" -> {:lessThan}
      operator == ">=" or operator == "ge" -> {:greaterThanOrEqual}
      operator == "<=" or operator == "le" -> {:lessThanOrEqual}
      true -> {:error}
    end
  end

  defp get_type(x) do
    if is_date(x) do
      {:date}
    end

    cond do
      is_integer(x) -> {:number}
      is_boolean(x) -> {:boolean}
      is_float({x}) -> {:float}
      is_binary(x) -> {:string}
      true -> {:error}
    end
  end

  defp is_date(x) do
    cond do
      is_map(x) ->
        Map.has_key?(x, :__struct__)
        |> if do
          x.__struct__ === NaiveDateTime or x.__struct__ === Date
        end

      true ->
        false
    end
  end
end
