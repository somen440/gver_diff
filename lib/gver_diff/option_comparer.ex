defmodule GverDiff.OptionComparer do
  def compare?(%{:base => base, :target => target}, nil), do: base < target

  def compare?(%{:base => base, :target => target}, operator) do
    case check_operator(operator) do
      {:equal} -> base === target
      {:notEqual} -> base !== target
      {:greaterThan} -> base > target
      {:lessThan} -> base < target
      {:greaterThanOrEqual} -> base >= target
      {:lessThanOrEqual} -> base <= target
      {:error} -> false
    end
  end

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
end
