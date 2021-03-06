defmodule GverDiff.OptionConverter do
  @spec convert(Compares.t(), any) :: Compares.t() | TypeAndCompares.t()
  def convert(%{:base => base, :target => target}, []) do
    %Compares{
      :base => convert_integer(base),
      :target => convert_integer(target)
    }
  end

  def convert(
        %{:base => base, :target => target} = values,
        [%GverDiffType{:name => type}]
      ) do
    case type do
      :string ->
        %TypeAndCompares{
          :id => :string,
          :compares => %Compares{:base => base, :target => target}
        }

      :integer ->
        %TypeAndCompares{
          :id => :integer,
          :compares => %Compares{
            :base => convert_integer(base),
            :target => convert_integer(target)
          }
        }

      :float ->
        %TypeAndCompares{
          :id => :float,
          :compares => %Compares{
            :base => convert_float(base),
            :target => convert_float(target)
          }
        }

      :datetime ->
        %TypeAndCompares{
          :id => :datetime,
          :compares => %Compares{
            :base => convert_datetime(base),
            :target => convert_datetime(target)
          }
        }

      :date ->
        %TypeAndCompares{
          :id => :date,
          :compares => %Compares{
            :base => convert_date(base),
            :target => convert_date(target)
          }
        }

      :version ->
        %TypeAndCompares{
          :id => :version,
          :compares => %Compares{
            :base => convert_version(base),
            :target => convert_version(target)
          }
        }

      _ ->
        raise "Error!! undefined type."
    end
  end

  def convert(
        %{:base => base, :target => target},
        [type, {:regex, regex}]
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
      %Compares{
        :base => extract_version.(base),
        :target => extract_version.(target)
      },
      [type]
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
