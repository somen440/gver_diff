defmodule GverDiff.OptionConverter do
  def convert({[base: base, target: target], _, _}) do
    {cast_base, _} = Integer.parse(base)
    {cast_target, _} = Integer.parse(target)

    %{
      :base => cast_base,
      :target => cast_target
    }
  end
end
