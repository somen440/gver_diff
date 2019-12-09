defmodule GverDiff.OptionComparer do
  @spec compare?(Compares.t() | TypeAndCompares.t(), any) :: boolean
  def compare?(%Compares{:base => base, :target => target}, nil) do
    cond do
      get_type(base) === get_type(target) -> base < target
      true -> false
    end
  end

  def compare?(%Compares{:base => base, :target => target}, operator) do
    cond do
      get_type(base) === get_type(target) ->
        case check_operator(operator) do
          :eq -> base === target
          :ne -> base !== target
          :gt -> base > target
          :lt -> base < target
          :ge -> base >= target
          :le -> base <= target
        end

      true ->
        false
    end
  end

  def compare?(%TypeAndCompares{:id => :string, :compares => values}, operator),
    do: values |> compare?(operator)

  def compare?(%TypeAndCompares{:id => :integer, :compares => values}, operator),
    do: values |> compare?(operator)

  def compare?(%TypeAndCompares{:id => :float, :compares => values}, operator),
    do: values |> compare?(operator)

  def compare?(
        %TypeAndCompares{
          :id => :datetime,
          :compares => %Compares{:base => base, :target => target}
        },
        operator
      ) do
    case NaiveDateTime.compare(base, target) do
      :eq ->
        case check_operator(operator) do
          :eq -> true
          :ge -> true
          :le -> true
          _ -> false
        end

      :lt ->
        case check_operator(operator) do
          :le -> true
          :lt -> true
          :ne -> true
          _ -> false
        end

      :gt ->
        case check_operator(operator) do
          :ge -> true
          :gt -> true
          :ne -> true
          _ -> false
        end
    end
  end

  def compare?(
        %TypeAndCompares{
          :id => :date,
          :compares => %Compares{:base => base, :target => target}
        },
        operator
      ) do
    case Date.compare(base, target) do
      :eq ->
        case check_operator(operator) do
          :eq -> true
          :ge -> true
          :le -> true
          _ -> false
        end

      :lt ->
        case check_operator(operator) do
          :le -> true
          :lt -> true
          :ne -> true
          _ -> false
        end

      :gt ->
        case check_operator(operator) do
          :ge -> true
          :gt -> true
          :ne -> true
          _ -> false
        end
    end
  end

  def compare?(
        %TypeAndCompares{
          :id => :version,
          :compares => %Compares{:base => base, :target => target}
        },
        operator
      ) do
    case check_operator(operator) do
      :eq -> base === target
      :ne -> base !== target
      :gt -> Version.match?(base, "> " <> target)
      :lt -> Version.match?(base, "< " <> target)
      :ge -> Version.match?(base, ">= " <> target)
      :le -> Version.match?(base, "<=" <> target)
    end
  end

  defp check_operator(operator) do
    cond do
      operator == "==" or operator == "eq" -> :eq
      operator == "!=" or operator == "ne" or operator == "<>" -> :ne
      operator == ">" or operator == "gt" -> :gt
      operator == "<" or operator == "lt" -> :lt
      operator == ">=" or operator == "ge" -> :ge
      operator == "<=" or operator == "le" -> :le
      true -> raise "Error!! undefined operator."
    end
  end

  defp get_type(x) do
    if is_date(x) do
      {:date}
    end

    cond do
      is_integer(x) -> {:number}
      is_boolean(x) -> {:boolean}
      is_float(x) -> {:float}
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
